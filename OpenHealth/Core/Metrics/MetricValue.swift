struct MetricValue: Equatable, Sendable {
    let id: MetricID
    let value: Double?
    let goal: Double?
    let subtitle: String?

    var progress: Double? {
        guard let value, let goal, goal > 0 else { return nil }
        return value / goal
    }

    var number: String { value.map(id.descriptor.format.number) ?? "—" }
    var unit: String { value == nil ? "" : id.descriptor.format.unit }
    var goalText: String? { goal.map { "of \(id.descriptor.format.number($0))" } }
}
