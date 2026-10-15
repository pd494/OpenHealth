/// Everything a ring or pill needs to know about a metric. The values are hard-coded placeholders until real data is wired in.
struct MetricDescriptor {
    let id: MetricID
    let title: String
    let symbol: String
    let domain: MetricDomain
    let format: MetricFormat
    let goal: Double
    let value: Double
    /// False for readings like resting heart rate, where progress toward a target means nothing.
    var hasGoal = true

    var progress: Double { value / goal }
    var number: String { format.number(value) }
    var unit: String { format.unit }

    /// "%" hugs the number; any other unit is spaced off it.
    var unitSuffix: String { unit == "%" || unit.isEmpty ? unit : " \(unit)" }
    /// The suffix on the ring, which drops "steps" because the title already says it.
    var ringSuffix: String { unit == "steps" ? "" : unitSuffix }

    /// Number and unit as one string, such as "412 kcal" or "71%".
    var valueText: String { number + ringSuffix }
    var goalText: String { format.number(goal) + unitSuffix }
}
