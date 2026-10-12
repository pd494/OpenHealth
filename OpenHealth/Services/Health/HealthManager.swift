import Foundation
import HealthKit
import Observation
import WidgetKit

@MainActor @Observable
final class HealthManager {
    static let shared = HealthManager()

    var steps = 0
    var sleepHours = 0.0
    var waterOunces = 0.0
    var recoveryScore: Int?
    var hrv = Vital()
    var rhr = Vital()
    var stressDay: StressDay?
    var sleepNight: SleepNight?
    var trends: [MetricID: [DayValue]] = [:]
    var readings: [MetricID: Double] = [:]

    var lastUpdated: Date?
    var stepsCheckedAt: Date?
    var waterCheckedAt: Date?
    var deviceSyncedAt: Date?

    var errorMessage: String?
    var isConnected = false
    var isLoading = false
    var isDemo = false
    var googleStepWakeupsEnabled = Defaults[.googleStepWakeupsEnabled] ?? false
    var googleStepShareDetected = false
    private(set) var stepSource: StepSource

    var stepGoal: Int {
        didSet { Defaults[.stepGoal] = stepGoal; publishWidget() }
    }
    var sleepGoal: Double {
        didSet { Defaults[.sleepGoal] = sleepGoal }
    }
    var waterGoal: Double {
        didSet { Defaults[.waterGoal] = waterGoal; publishWidget() }
    }

    var stepsProgress: Double { Double(steps) / Double(stepGoal) }
    var waterProgress: Double { waterOunces / waterGoal }

    let store = HKHealthStore()
    let reader: HealthKitReader
    private var observerQueries: [HKObserverQuery] = []

    init() {
        reader = HealthKitReader(store: store)
        stepSource = Defaults[.stepSource].flatMap(StepSource.init) ?? .apple
        stepGoal = Defaults[.stepGoal] ?? Int(MetricID.steps.descriptor.defaultGoal ?? 0)
        sleepGoal = Defaults[.sleepGoal] ?? MetricID.sleep.descriptor.defaultGoal ?? 0
        waterGoal = Defaults[.waterGoal] ?? MetricID.hydration.descriptor.defaultGoal ?? 0
        isConnected = Defaults[.appleHealthConnected] ?? false

        if stepSource == .google {
            let snapshot = SnapshotStore.load()
            steps = snapshot.steps
            lastUpdated = snapshot.updatedAt == .distantPast ? nil : snapshot.updatedAt
            stepsCheckedAt = snapshot.stepsCheckedAt == .distantPast ? nil : snapshot.stepsCheckedAt
        }
        if !isConnected {
            waterOunces = LocalWater.today()
        }
    }

    func startObservers() {
        guard HKHealthStore.isHealthDataAvailable(), observerQueries.isEmpty else { return }
        for type in HealthTypes.all {
            let query = HKObserverQuery(sampleType: type, predicate: nil) { [weak self] _, completion, _ in
                Task { @MainActor in
                    if self?.isConnected == true { await self?.refresh() }
                    if type == HealthTypes.steps,
                       self?.googleStepWakeupsEnabled == true,
                       GoogleHealthManager.shared.isConnected {
                        await self?.checkGoogleSharedSteps()
                    }
                    completion()
                }
            }
            observerQueries.append(query)
            store.execute(query)
        }
    }

    func connect() async {
        guard HKHealthStore.isHealthDataAvailable() else {
            errorMessage = "Apple Health is unavailable on this device. Use Demo Mode here, or test on an iPhone."
            return
        }
        do {
            try await store.requestAuthorization(toShare: [HealthTypes.water], read: Set<HKObjectType>(HealthTypes.all))
            isDemo = false
            isConnected = true
            if !GoogleHealthManager.shared.isConnected {
                use(.apple)
            }
            Defaults[.appleHealthConnected] = true
            for type in HealthTypes.all {
                try await store.enableBackgroundDelivery(for: type, frequency: .immediate)
            }
            startObservers()
            await refresh()
        } catch {
            errorMessage = "Apple Health connection failed: \(error.localizedDescription)"
        }
    }

    func refresh() async {
        guard isConnected, !isDemo, HKHealthStore.isHealthDataAvailable() else { return }
        isLoading = true
        defer { isLoading = false }

        let now = Date.now
        let startOfDay = Calendar.current.startOfDay(for: now)
        let sleepStart = startOfDay.adding(-12, .hour)
        let baselineStart = startOfDay.adding(-7, .day)

        async let latestSteps = reader.sum(HealthTypes.steps, from: startOfDay, to: now, unit: .count())
        async let latestWater = reader.sum(HealthTypes.water, from: startOfDay, to: now, unit: .fluidOunceUS())
        async let latestSleep = reader.sleepHours(from: sleepStart, to: now)
        async let hrvToday = reader.average(HealthTypes.hrv, from: startOfDay, to: now, unit: .milliseconds)
        async let rhrToday = reader.average(HealthTypes.restingHeartRate, from: startOfDay, to: now, unit: .beatsPerMinute)
        async let hrvBaseline = reader.average(HealthTypes.hrv, from: baselineStart, to: startOfDay, unit: .milliseconds)
        async let rhrBaseline = reader.average(HealthTypes.restingHeartRate, from: baselineStart, to: startOfDay, unit: .beatsPerMinute)

        waterOunces = await latestWater
        waterCheckedAt = now

        // Steps, sleep and vitals belong to whichever source is active; Google data wins when connected.
        let appleSteps = Int((await latestSteps).rounded())
        let appleSleep = await latestSleep
        let appleHRV = Vital(today: await hrvToday, baseline: await hrvBaseline)
        let appleRHR = Vital(today: await rhrToday, baseline: await rhrBaseline)
        if stepSource == .apple {
            steps = appleSteps
            stepsCheckedAt = now
            sleepHours = appleSleep
            hrv = appleHRV
            rhr = appleRHR
            recoveryScore = Recovery.score(sleep: appleSleep, goal: sleepGoal, hrv: appleHRV, rhr: appleRHR)
        }
        let apple = try? await HealthKitMetricSource(reader: reader).values(for: Set(MetricID.allCases), on: now)
        if stepSource == .apple { readings = apple ?? [:] }
        readings[.recovery] = recoveryScore.map(Double.init)
        await refreshSleepDetails()
        await refreshTrends()
        await refreshStress()
        lastUpdated = now
        publishWidget()
    }

    func addWater(ounces: Double) async {
        guard ounces > 0, ounces <= 128 else {
            errorMessage = "Enter between 1 and 128 oz."
            return
        }
        if stepSource == .google {
            LocalWater.save(LocalWater.today() + ounces)
            waterOunces = (readings[.hydration] ?? 0) + LocalWater.today()
            waterCheckedAt = .now
            lastUpdated = .now
            publishWidget()
            return
        }
        guard isConnected else {
            waterOunces += ounces
            if !isDemo { LocalWater.save(waterOunces) }
            lastUpdated = .now
            waterCheckedAt = .now
            publishWidget()
            return
        }
        let now = Date.now
        let quantity = HKQuantity(unit: .fluidOunceUS(), doubleValue: ounces)
        do {
            try await store.save(HKQuantitySample(type: HealthTypes.water, quantity: quantity, start: now, end: now))
            await refresh()
        } catch {
            errorMessage = "Water could not be saved: \(error.localizedDescription)"
        }
    }

    func checkDayRollover() {
        guard !isConnected, !isDemo else { return }
        let current = LocalWater.today()
        if waterOunces != current {
            waterOunces = current
            waterCheckedAt = nil
            lastUpdated = .now
            publishWidget()
        }
    }

    func loadDemo() {
        isDemo = true
        isConnected = false
        stepSource = .demo
        deviceSyncedAt = nil
        let demo = DemoMetricSource.values
        readings = demo
        steps = Int(demo[.steps] ?? 0)
        sleepHours = demo[.sleep] ?? 0
        waterOunces = demo[.hydration] ?? 0
        stepsCheckedAt = .now
        waterCheckedAt = .now
        recoveryScore = demo[.recovery].map { Int($0) }
        hrv = Vital(today: demo[.hrv], baseline: 48)
        rhr = Vital(today: demo[.restingHR], baseline: 60)
        stressDay = DemoStress.day()
        sleepNight = DemoSleep.night()
        trends = DemoTrends.trends()
        readings[.stress] = stressDay?.current?.score
        lastUpdated = .now
        publishWidget()
    }

    func use(_ source: StepSource) {
        stepSource = source
        if source != .demo { Defaults[.stepSource] = source.rawValue }
        if source == .apple { deviceSyncedAt = nil }
    }

    func publishWidget(reload: Bool = true) {
        SnapshotStore.save(.init(
            steps: steps,
            stepGoal: stepGoal,
            waterOunces: waterOunces,
            waterGoal: waterGoal,
            sourceName: stepSource.displayName,
            updatedAt: lastUpdated ?? .now,
            stepsCheckedAt: stepsCheckedAt ?? .distantPast,
            waterCheckedAt: waterCheckedAt ?? .distantPast,
            deviceSyncedAt: deviceSyncedAt
        ))
        if reload {
            WidgetCenter.shared.reloadTimelines(ofKind: WidgetKind.steps)
            WidgetCenter.shared.reloadTimelines(ofKind: WidgetKind.hydration)
        }
    }
}
