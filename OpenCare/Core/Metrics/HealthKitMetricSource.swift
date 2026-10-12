import HealthKit

struct HealthKitMetricSource: MetricSource {
    let reader: HealthKitReader

    func values(for ids: Set<MetricID>, on day: Date) async throws -> [MetricID: Double] {
        let start = Calendar.current.startOfDay(for: day)
        let end = start.adding(1, .day)
        var result: [MetricID: Double] = [:]
        await withTaskGroup(of: (MetricID, Double?).self) { group in
            for id in ids {
                group.addTask { (id, await read(id, from: start, to: end)) }
            }
            for await (id, value) in group {
                if let value { result[id] = value }
            }
        }
        return result
    }

    func dailyValues(_ id: MetricID, days: Int) async -> [DayValue] {
        let start = Calendar.current.startOfDay(for: .now).adding(1 - days, .day)
        switch id {
        case .steps: return await reader.dailySums(HealthTypes.steps, unit: .count(), from: start)
        case .distance: return await reader.dailySums(HealthTypes.distance, unit: .mile(), from: start)
        case .activeEnergy: return await reader.dailySums(HealthTypes.activeEnergy, unit: .kilocalorie(), from: start)
        case .exerciseMinutes: return await reader.dailySums(HealthTypes.exerciseTime, unit: .minute(), from: start)
        default: return []
        }
    }

    private func read(_ id: MetricID, from start: Date, to end: Date) async -> Double? {
        switch id {
        case .steps: await sum(HealthTypes.steps, .count(), start, end)
        case .distance: await sum(HealthTypes.distance, .mile(), start, end)
        case .activeEnergy: await sum(HealthTypes.activeEnergy, .kilocalorie(), start, end)
        case .totalEnergy:
            await sum(HealthTypes.activeEnergy, .kilocalorie(), start, end)
                + sum(HealthTypes.basalEnergy, .kilocalorie(), start, end)
        case .exerciseMinutes: await sum(HealthTypes.exerciseTime, .minute(), start, end)
        case .heartRate: await reader.latest(HealthTypes.heartRate, unit: .beatsPerMinute)
        case .restingHR: await reader.average(HealthTypes.restingHeartRate, from: start, to: end, unit: .beatsPerMinute)
        case .hrv: await reader.average(HealthTypes.hrv, from: start, to: end, unit: .milliseconds)
        case .weight: await reader.latest(HealthTypes.bodyMass, unit: .pound())
        case .hydration: await sum(HealthTypes.water, .fluidOunceUS(), start, end)
        case .sleep: await reader.sleepHours(from: start.adding(-12, .hour), to: min(end, .now))
        case .caloriesIn: await sum(HealthTypes.dietaryEnergy, .kilocalorie(), start, end)
        case .protein: await sum(HealthTypes.protein, .gram(), start, end)
        case .carbs: await sum(HealthTypes.carbs, .gram(), start, end)
        case .fat: await sum(HealthTypes.fat, .gram(), start, end)
        case .recovery, .stress: nil
        }
    }

    private func sum(_ type: HKQuantityType, _ unit: HKUnit, _ start: Date, _ end: Date) async -> Double {
        await reader.sum(type, from: start, to: end, unit: unit)
    }
}
