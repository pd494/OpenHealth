/// Which metrics are rings and which are pills below them, each in the user's order.
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
        .init(metric: .fat, isVisible: false),
        .init(metric: .activeZoneMinutes, isVisible: false),
        .init(metric: .restingHeartRate, isVisible: false),
        .init(metric: .hrv, isVisible: false),
        .init(metric: .weight, isVisible: false),
        .init(metric: .floors, isVisible: false),
        .init(metric: .runningDistance, isVisible: false),
        .init(metric: .heartRate, isVisible: false),
        .init(metric: .readiness, isVisible: false),
        .init(metric: .weeklyCardio, isVisible: false),
        .init(metric: .vitals, isVisible: false),
        .init(metric: .exerciseDays, isVisible: false),
        .init(metric: .netCalories, isVisible: false)
    ])

    var rings: [DashboardItem] { items.filter(\.isVisible) }
    var hidden: [DashboardItem] { items.filter { !$0.isVisible } }

    /// A saved layout predates any metric added since; those join the hidden list. Metrics without a goal are never rings.
    func filledOut() -> DashboardLayout {
        let known = Set(items.map(\.metric))
        let missing = MetricID.allCases.filter { !known.contains($0) }
        let all = items + missing.map { DashboardItem(metric: $0, isVisible: false) }
        return DashboardLayout(items: all.map { DashboardItem(metric: $0.metric, isVisible: $0.isVisible && $0.metric.descriptor.hasGoal) })
    }

    /// Metrics without a goal can't be rings, so showing one is ignored.
    mutating func setVisible(_ id: MetricID, _ visible: Bool) {
        guard let index = items.firstIndex(where: { $0.metric == id }),
              !visible || id.descriptor.hasGoal else { return }
        items[index].isVisible = visible
    }

    /// Turns a ring into a metric pill, landing at `position` among the pills.
    mutating func hide(_ id: MetricID, at position: Int = 0) {
        setVisible(id, false)
        move(id, to: position)
    }

    /// Moves a metric so it lands at `position` among the others of its kind (rings or hidden), the rest shifting to make room.
    mutating func move(_ id: MetricID, to position: Int) {
        guard let from = items.firstIndex(where: { $0.metric == id }) else { return }
        let item = items.remove(at: from)
        let peers = items.indices.filter { items[$0].isVisible == item.isVisible }
        let insertAt = position < peers.count ? peers[max(position, 0)] : (peers.last.map { $0 + 1 } ?? items.count)
        items.insert(item, at: insertAt)
    }

    /// Swaps a metric with its neighbour among those of its kind (rings or hidden).
    mutating func shift(_ id: MetricID, by offset: Int) {
        guard let visible = items.first(where: { $0.metric == id })?.isVisible else { return }
        let peers = items.filter { $0.isVisible == visible }.map(\.metric)
        guard let from = peers.firstIndex(of: id), peers.indices.contains(from + offset),
              let a = items.firstIndex(where: { $0.metric == id }),
              let b = items.firstIndex(where: { $0.metric == peers[from + offset] }) else { return }
        items.swapAt(a, b)
    }
}

struct DashboardItem: Codable, Hashable, Identifiable {
    let metric: MetricID
    var isVisible: Bool

    var id: MetricID { metric }
}
