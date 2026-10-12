import Foundation
import Observation

@MainActor @Observable
final class GoogleHealthManager {
    static let shared = GoogleHealthManager()

    var isConnected = false
    var isSyncing = false
    var errorMessage: String?
    var lastChecked: Date?
    var lastAirSync: Date?
    var airName: String?
    var dailySteps: [DailyStepCount] = []

    var isConfigured: Bool { config != nil }

    private static let minimumSyncInterval: TimeInterval = 60

    private let config = GoogleOAuthConfig()
    private let oauth = GoogleOAuth()

    private var health: HealthManager { .shared }

    init() {
        isConnected = GoogleTokenStore.load() != nil
    }

    func connect() async {
        guard let config else {
            errorMessage = "Set up a Google Health iOS OAuth client ID first. OpenHealth is ready for it in the project settings."
            return
        }
        do {
            let newTokens = try await oauth.signIn(config: config)
            try GoogleTokenStore.save(newTokens)
            isConnected = true
            await sync()
        } catch {
            if !GoogleOAuth.isCancellation(error) {
                errorMessage = error.localizedDescription
            }
        }
    }

    func sync(force: Bool = false) async {
        guard isConnected, !isSyncing else { return }
        if !force, let lastChecked, Date.now.timeIntervalSince(lastChecked) < Self.minimumSyncInterval { return }
        isSyncing = true
        defer { isSyncing = false }
        do {
            let api = GoogleHealthAPI()
            dailySteps = try await api.dailySteps()
            let steps = dailySteps.first { Calendar.current.isDateInToday($0.date) }?.count ?? 0

            // Show steps right away; they work even when the user grants only the activity scope.
            if health.isDemo {
                health.readings = [:]
                health.trends = [:]
                health.sleepNight = nil
                health.stressDay = nil
            }
            health.applyGoogleSteps(steps)
            lastChecked = .now

            let air = try? await api.pairedAir()
            airName = air?.name
            lastAirSync = air?.lastSync

            let sleep = try? await api.lastSleepHours()
            let hrvHistory = try? await api.dailyMetric(.heartRateVariability)
            let rhrHistory = try? await api.dailyMetric(.restingHeartRate)
            let hrv = Vital(today: hrvHistory?.first?.value, baseline: hrvHistory.flatMap(Self.baseline))
            let rhr = Vital(today: rhrHistory?.first?.value, baseline: rhrHistory.flatMap(Self.baseline))
            health.applyGoogleData(
                steps: steps,
                sleep: sleep,
                recovery: recovery(sleep: sleep, hrvHistory: hrvHistory, rhrHistory: rhrHistory, hrv: hrv, rhr: rhr),
                hrv: hrv,
                rhr: rhr,
                deviceSyncedAt: lastAirSync
            )
            health.trends[.steps] = dailySteps.map { DayValue(date: $0.date, value: Double($0.count)) }
            health.trends[.hrv] = (hrvHistory ?? []).map { DayValue(date: $0.date, value: $0.value) }
            health.trends[.restingHR] = (rhrHistory ?? []).map { DayValue(date: $0.date, value: $0.value) }
            await syncDashboard(api: api)
        } catch {
            errorMessage = "Google Health sync failed: \(error.localizedDescription)"
        }
    }

    private func syncDashboard(api: GoogleHealthAPI) async {
        let rollupTypes = [
            "active-energy-burned", "total-calories", "distance", "heart-rate", "weight",
            "body-fat", "run-vo2-max", "blood-glucose", "core-body-temperature", "altitude",
            "floors", "active-zone-minutes", "active-minutes", "nutrition-log", "hydration-log"
        ]
        for id in [MetricID.activeEnergy, .totalEnergy, .distance, .heartRate, .weight, .bodyFat, .vo2Max, .bloodGlucose, .bodyTemperature, .elevationGain, .floors, .activeZoneMinutes, .caloriesIn, .carbs, .fat, .protein, .hydration, .exerciseMinutes] {
            health.readings[id] = nil
            health.trends[id] = []
        }
        await withTaskGroup(of: DailyDashboardResponse?.self) { group in
            for dataType in rollupTypes {
                group.addTask { try? await api.dailyDashboard(dataType) }
            }
            for await response in group {
                let points = (response?.rollupDataPoints ?? []).sorted {
                    ($0.civilStartTime?.date.startOfDay ?? .distantPast) > ($1.civilStartTime?.date.startOfDay ?? .distantPast)
                }
                for point in points {
                    guard let date = point.civilStartTime?.date.startOfDay else { continue }
                    for (name, value) in point.values {
                        guard let id = MetricID(rawValue: name) else { continue }
                        let latestMeasurement = [.weight, .bodyFat, .vo2Max, .bloodGlucose, .bodyTemperature].contains(id)
                        if Calendar.current.isDateInToday(date) || (latestMeasurement && date == points.first?.civilStartTime?.date.startOfDay) {
                            health.readings[id] = value
                        }
                        health.trends[id, default: []].append(DayValue(date: date, value: value))
                    }
                }
            }
        }
        for (id, kind) in [(MetricID.oxygenSaturation, DailyMetricKind.oxygenSaturation), (.respiratoryRate, .respiratoryRate), (.skinTemperature, .skinTemperature)] {
            if let history = try? await api.dailyMetric(kind) {
                health.readings[id] = history.first?.value
                health.trends[id] = history.map { DayValue(date: $0.date, value: $0.value) }
            }
        }
        for id in health.trends.keys {
            health.trends[id]?.sort { $0.date < $1.date }
        }
        health.waterOunces = (health.readings[.hydration] ?? 0) + LocalWater.today()
        health.publishWidget()
    }

    /// Skips sleep and vitals so it is cheap enough to poll.
    func syncStepsOnly() async {
        guard isConnected, !isSyncing else { return }
        isSyncing = true
        defer { isSyncing = false }
        do {
            let api = GoogleHealthAPI()
            dailySteps = try await api.dailySteps(daysBack: 0)
            let steps = dailySteps.first { Calendar.current.isDateInToday($0.date) }?.count ?? 0
            lastChecked = .now
            let air = try? await api.pairedAir()
            airName = air?.name
            lastAirSync = air?.lastSync
            health.applyGoogleSteps(steps, deviceSyncedAt: lastAirSync)
        } catch {
            errorMessage = "Google Health step check failed: \(error.localizedDescription)"
        }
    }

    func disconnect() {
        GoogleTokenStore.delete()
        isConnected = false
        dailySteps = []
        lastChecked = nil
        lastAirSync = nil
        airName = nil
        Task { await health.googleDisconnected() }
    }

    private func recovery(sleep: Double?, hrvHistory: [DailyMetric]?, rhrHistory: [DailyMetric]?, hrv: Vital, rhr: Vital) -> Int? {
        guard let sleep, let latestHRV = hrvHistory?.first, let latestRHR = rhrHistory?.first else { return nil }
        let cutoff = Calendar.current.startOfDay(for: Date.now.adding(-2, .day))
        guard latestHRV.date >= cutoff, latestRHR.date >= cutoff else { return nil }
        return Recovery.score(sleep: sleep, goal: health.sleepGoal, hrv: hrv, rhr: rhr)
    }

    private static func baseline(_ metrics: [DailyMetric]) -> Double? {
        Recovery.baseline(of: metrics.dropFirst().map(\.value))
    }
}
