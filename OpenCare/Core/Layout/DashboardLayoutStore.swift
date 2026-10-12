import Foundation
import Observation

@MainActor @Observable
final class DashboardLayoutStore {
    private(set) var layout: DashboardLayout {
        didSet { save() }
    }

    init(layout: DashboardLayout? = nil) {
        var initial = layout ?? Self.load()
        #if DEBUG
        DebugLaunch.apply(to: &initial)
        #endif
        self.layout = initial
    }

    func moveTile(_ id: MetricID, to index: Int) {
        let canonical = DashboardLayout.canonical(id)
        let others = layout.tiles.map(\.metric).filter { DashboardLayout.canonical($0) != canonical }
        layout.move(id, before: index < others.count ? others[index] : nil)
    }

    func shiftRing(_ id: MetricID, by offset: Int) {
        let canonical = DashboardLayout.canonical(id)
        let ids = layout.rings.map(\.metric).map(DashboardLayout.canonical)
        guard let from = ids.firstIndex(of: canonical), ids.indices.contains(from + offset) else { return }
        let target = from + offset
        layout.move(id, before: offset > 0 ? (target + 1 < ids.count ? ids[target + 1] : nil) : ids[target])
    }

    func setVisible(_ id: MetricID, _ visible: Bool) { layout.setVisible(id, visible) }
    func setStyle(_ id: MetricID, _ style: DisplayStyle) { layout.setStyle(id, style) }
    func setRingsMode(_ mode: RingsMode) { layout.ringsMode = mode }
    func setTileLayout(_ tileLayout: TileLayout) { layout.tileLayout = tileLayout }
    func setCalories(_ calories: CaloriePreference) { layout.calories = calories }
    func toggleRingDetails() { layout.ringDetailsCollapsed.toggle() }
    func reset() { layout = .default }

    private func save() {
        // Encoding a plain Codable struct cannot fail; nothing useful to do if it somehow does.
        Defaults[.dashboardLayout] = try? JSONEncoder().encode(layout)
    }

    private static func load() -> DashboardLayout {
        guard let data = Defaults[.dashboardLayout],
              let stored = try? JSONDecoder().decode(DashboardLayout.self, from: data) else { return .default }
        return stored.reconciled()
    }
}
