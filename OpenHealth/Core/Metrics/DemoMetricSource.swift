import Foundation

struct DemoMetricSource: MetricSource {
    static let values: [MetricID: Double] = MetricRegistry.all.mapValues(\.demo)

    func values(for ids: Set<MetricID>, on day: Date) async throws -> [MetricID: Double] {
        Self.values.filter { ids.contains($0.key) }
    }
}
