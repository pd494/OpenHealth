/// Which metrics are shown as rings, and in what order. Hidden metrics wait in the Add sheet.
struct DashboardLayout: Codable, Equatable {
    var items: [DashboardItem]

    static let `default` = DashboardLayout(items: [
        .init(metric: .steps, isVisible: true),
        .init(metric: .recovery, isVisible: true),
        .init(metric: .sleep, isVisible: true),
        .init(metric: .hydration, isVisible: true),
        .init(metric: .distance, isVisible: true),
        .init(metric: .caloriesIn, isVisible: true),
        .init(metric: .activeEnergy, isVisible: false),
        .init(metric: .exerciseMinutes, isVisible: false),
        .init(metric: .protein, isVisible: false),
        .init(metric: .carbs, isVisible: false),
        .init(metric: .fat, isVisible: false)
    ])

    var rings: [DashboardItem] { items.filter(\.isVisible) }
    var hidden: [DashboardItem] { items.filter { !$0.isVisible } }

    mutating func setVisible(_ id: MetricID, _ visible: Bool) {
        guard let index = items.firstIndex(where: { $0.metric == id }) else { return }
        items[index].isVisible = visible
    }

    /// Swaps a ring with its neighbour among the visible rings.
    mutating func shift(_ id: MetricID, by offset: Int) {
        let shown = rings.map(\.metric)
        guard let from = shown.firstIndex(of: id), shown.indices.contains(from + offset),
              let a = items.firstIndex(where: { $0.metric == id }),
              let b = items.firstIndex(where: { $0.metric == shown[from + offset] }) else { return }
        items.swapAt(a, b)
    }
}
