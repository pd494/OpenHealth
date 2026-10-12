struct DashboardItem: Codable, Hashable, Identifiable {
    let metric: MetricID
    var isVisible: Bool
    var style: DisplayStyle

    var id: MetricID { metric }
}
