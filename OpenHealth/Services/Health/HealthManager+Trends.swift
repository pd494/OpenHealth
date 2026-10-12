import Foundation

extension HealthManager {
    static let trendMetrics = MetricID.allCases.filter { $0.descriptor.healthKit?.trendType != nil }

    func refreshTrends() async {
        let source = HealthKitMetricSource(reader: reader)
        trends = await withTaskGroup(of: (MetricID, [DayValue]).self) { group in
            for id in Self.trendMetrics {
                group.addTask { (id, await source.dailyValues(id, days: 7)) }
            }
            var result: [MetricID: [DayValue]] = [:]
            for await (id, values) in group { result[id] = values }
            return result
        }
    }
}
