struct DashboardItem: Codable, Hashable, Identifiable {
    let metric: MetricID
    var isVisible: Bool

    var id: MetricID { metric }
}
