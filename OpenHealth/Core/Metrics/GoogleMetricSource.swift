import Foundation

/// Adapts the values the Google Health sync already produces.
struct GoogleMetricSource: MetricSource {
    var steps: Int
    var sleepHours: Double?
    var recovery: Int?
    var hrv: Double?
    var restingHR: Double?

    var snapshot: [MetricID: Double] {
        let all: [MetricID: Double?] = [
            .steps: Double(steps), .sleep: sleepHours, .recovery: recovery.map(Double.init),
            .hrv: hrv, .restingHR: restingHR
        ]
        return all.compactMapValues { $0 }
    }

    func values(for ids: Set<MetricID>, on day: Date) async throws -> [MetricID: Double] {
        snapshot.filter { ids.contains($0.key) }
    }
}
