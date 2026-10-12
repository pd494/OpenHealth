import HealthKit

/// Reads any metric whose descriptor declares a `HealthQuery`.
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

    /// Daily totals for summed metrics; empty for anything else.
    func dailyValues(_ id: MetricID, days: Int) async -> [DayValue] {
        guard let (type, unit) = id.descriptor.healthKit?.trendType else { return [] }
        let start = Calendar.current.startOfDay(for: .now).adding(1 - days, .day)
        return await reader.dailySums(type, unit: unit, from: start)
    }

    private func read(_ id: MetricID, from start: Date, to end: Date) async -> Double? {
        switch id.descriptor.healthKit {
        case .sum(let types, let unit):
            var total = 0.0
            for type in types { total += await reader.sum(type, from: start, to: end, unit: unit) }
            return total
        case .average(let type, let unit): return await reader.average(type, from: start, to: end, unit: unit)
        case .latest(let type, let unit): return await reader.latest(type, unit: unit)
        case .sleep: return await reader.sleepHours(from: start.adding(-12, .hour), to: min(end, .now))
        case nil: return nil
        }
    }
}
