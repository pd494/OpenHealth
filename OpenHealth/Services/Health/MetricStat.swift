struct MetricStat: Identifiable, Equatable {
    let label: String
    let value: String
    var metric: MetricID?

    var id: String { label }
}
