/// Everything a ring needs to know about a metric. The values are hard-coded placeholders until real data is wired in.
struct MetricDescriptor {
    let id: MetricID
    let title: String
    let symbol: String
    let domain: MetricDomain
    let format: MetricFormat
    let goal: Double
    let value: Double

    var progress: Double { value / goal }
    var number: String { format.number(value) }
    var unit: String { format.unit }

    var goalText: String {
        let suffix = unit == "%" ? unit : (unit.isEmpty ? "" : " \(unit)")
        return "of \(format.number(goal))\(suffix)"
    }
}
