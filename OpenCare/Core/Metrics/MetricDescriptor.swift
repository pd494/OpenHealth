import SwiftUI

struct MetricDescriptor: Sendable {
    let id: MetricID
    let title: String
    let symbol: String
    let domain: MetricDomain
    let format: MetricFormat
    var defaultGoal: Double?

    var tint: Color { domain.tint }
    var supportsGoal: Bool { defaultGoal != nil }
}
