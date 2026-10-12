struct DashboardLayout: Codable, Equatable {
    static let currentSchemaVersion = 1

    var schemaVersion = currentSchemaVersion
    var items: [DashboardItem]
    var ringsMode = RingsMode.standard
    var ringDetailsCollapsed = false
    var calories = CaloriePreference.active
    var tileLayout = TileLayout.pills

    static let `default` = DashboardLayout(items: [
        .init(metric: .steps, isVisible: true, style: .ring),
        .init(metric: .recovery, isVisible: true, style: .ring),
        .init(metric: .sleep, isVisible: true, style: .ring),
        .init(metric: .hydration, isVisible: true, style: .tile),
        .init(metric: .activeEnergy, isVisible: true, style: .tile),
        .init(metric: .distance, isVisible: true, style: .tile),
        .init(metric: .heartRate, isVisible: true, style: .tile),
        .init(metric: .hrv, isVisible: true, style: .tile),
        .init(metric: .stress, isVisible: true, style: .tile),
        .init(metric: .caloriesIn, isVisible: true, style: .tile),
        .init(metric: .weight, isVisible: true, style: .tile),
        .init(metric: .restingHR, isVisible: false, style: .tile),
        .init(metric: .exerciseMinutes, isVisible: false, style: .tile),
        .init(metric: .protein, isVisible: false, style: .tile),
        .init(metric: .carbs, isVisible: false, style: .tile),
        .init(metric: .fat, isVisible: false, style: .tile)
    ])

    var rings: [DashboardItem] { displayed { $0.isVisible && $0.style == .ring } }
    var tiles: [DashboardItem] { displayed { $0.isVisible && $0.style == .tile } }
    var hidden: [DashboardItem] { displayed { !$0.isVisible } }

    /// The calorie slot is stored once as `.activeEnergy`; the preference picks which ID is shown.
    static func canonical(_ id: MetricID) -> MetricID { id == .totalEnergy ? .activeEnergy : id }

    mutating func move(_ id: MetricID, before target: MetricID?) {
        let id = Self.canonical(id)
        guard id != target.map(Self.canonical), let from = items.firstIndex(where: { $0.metric == id }) else { return }
        let item = items.remove(at: from)
        if let target, let to = items.firstIndex(where: { $0.metric == Self.canonical(target) }) {
            items.insert(item, at: to)
        } else if let last = items.lastIndex(where: { $0.isVisible && $0.style == item.style }) {
            items.insert(item, at: last + 1)
        } else {
            items.append(item)
        }
    }

    mutating func setVisible(_ id: MetricID, _ visible: Bool) {
        update(id) { $0.isVisible = visible }
    }

    /// Ignored for metrics without a goal, which can only be tiles.
    mutating func setStyle(_ id: MetricID, _ style: DisplayStyle) {
        guard style == .tile || id.descriptor.supportsGoal else { return }
        update(id) { $0.style = style }
    }

    /// Adds metrics introduced by an app update (hidden) and normalizes the calorie slot.
    func reconciled() -> DashboardLayout {
        var result = self
        var seen = Set<MetricID>()
        result.items = items.compactMap { item in
            let metric = Self.canonical(item.metric)
            guard seen.insert(metric).inserted else { return nil }
            var item = DashboardItem(metric: metric, isVisible: item.isVisible, style: item.style)
            if !metric.descriptor.supportsGoal { item.style = .tile }
            return item
        }
        for metric in MetricID.allCases where metric != .totalEnergy && !seen.contains(metric) {
            result.items.append(.init(metric: metric, isVisible: false, style: .tile))
        }
        return result
    }

    private mutating func update(_ id: MetricID, _ change: (inout DashboardItem) -> Void) {
        let id = Self.canonical(id)
        guard let index = items.firstIndex(where: { $0.metric == id }) else { return }
        change(&items[index])
    }

    private func displayed(where include: (DashboardItem) -> Bool) -> [DashboardItem] {
        items.filter(include).map { item in
            guard item.metric == .activeEnergy else { return item }
            return DashboardItem(metric: calories.metric, isVisible: item.isVisible, style: item.style)
        }
    }
}

extension DashboardLayout {
    private struct StoredItem: Decodable {
        let metric: String
        let isVisible: Bool
        let style: DisplayStyle
    }

    private enum CodingKeys: String, CodingKey {
        case schemaVersion, items, ringsMode, ringDetailsCollapsed, calories, tileLayout
    }

    /// Unknown metric IDs are dropped instead of failing, so removing a metric never wipes a saved layout.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        schemaVersion = try container.decodeIfPresent(Int.self, forKey: .schemaVersion) ?? Self.currentSchemaVersion
        items = try container.decode([StoredItem].self, forKey: .items).compactMap { stored in
            MetricID(rawValue: stored.metric).map { DashboardItem(metric: $0, isVisible: stored.isVisible, style: stored.style) }
        }
        ringsMode = try container.decodeIfPresent(RingsMode.self, forKey: .ringsMode) ?? .standard
        ringDetailsCollapsed = try container.decodeIfPresent(Bool.self, forKey: .ringDetailsCollapsed) ?? false
        calories = try container.decodeIfPresent(CaloriePreference.self, forKey: .calories) ?? .active
        tileLayout = try container.decodeIfPresent(TileLayout.self, forKey: .tileLayout) ?? .pills
    }
}
