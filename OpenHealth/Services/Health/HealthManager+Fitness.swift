import Foundation

extension HealthManager {
    func refreshFitness() async {
        var result: [MetricID: [DayValue]] = [:]
        for id in DemoFitness.trendMetrics {
            result[id] = await HealthKitMetricSource(reader: reader).dailyValues(id, days: 7)
        }
        trends = result
        workouts = await reader.workouts(limit: 8)
    }
}
