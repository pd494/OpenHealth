import SwiftUI

/// Everything the Today screen needs to know about a metric. Add new metrics in `MetricRegistry`.
struct MetricDescriptor: Sendable {
    let id: MetricID
    let title: String
    let symbol: String
    let domain: MetricDomain
    let format: MetricFormat
    var defaultGoal: Double?
    /// Where HealthKit reads it from; nil when it comes from elsewhere (Google, derived scores).
    var healthKit: HealthQuery?
    /// Fixed caption under the value; live captions (HRV baseline, stress band) stay in `HealthManager`.
    var subtitle: String?
    /// Value shown in preview mode.
    var demo: Double

    var tint: Color { domain.tint }
}
