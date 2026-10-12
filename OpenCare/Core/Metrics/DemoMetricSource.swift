import Foundation

struct DemoMetricSource: MetricSource {
    static let values: [MetricID: Double] = [
        .steps: 6_428, .distance: 3.1, .activeEnergy: 412, .totalEnergy: 1_532, .exerciseMinutes: 28,
        .heartRate: 72, .restingHR: 58, .hrv: 52, .recovery: 71, .weight: 168.4, .hydration: 44,
        .sleep: 7.2, .stress: 31, .caloriesIn: 1_640, .protein: 92, .carbs: 168, .fat: 54
    ]

    func values(for ids: Set<MetricID>, on day: Date) async throws -> [MetricID: Double] {
        Self.values.filter { ids.contains($0.key) }
    }
}
