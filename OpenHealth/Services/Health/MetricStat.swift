struct MetricStat: Identifiable, Equatable {
    let label: String
    let value: String

    var id: String { label }
}
