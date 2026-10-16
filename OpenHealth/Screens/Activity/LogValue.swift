enum LogValue {
    case water
    case weight

    var title: String { self == .water ? "Log water" : "Log weight" }
    var unit: String { self == .water ? "oz" : "lb" }
    var defaultAmount: Double { self == .water ? 8 : MetricID.weight.descriptor.value }
    var step: Double { self == .water ? 1 : 0.2 }
    var symbol: String { self == .water ? "drop.fill" : "scalemass.fill" }
    var domain: MetricDomain { self == .water ? .hydration : .body }
}
