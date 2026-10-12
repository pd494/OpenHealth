import Foundation

protocol MetricSource: Sendable {
    func values(for ids: Set<MetricID>, on day: Date) async throws -> [MetricID: Double]
}
