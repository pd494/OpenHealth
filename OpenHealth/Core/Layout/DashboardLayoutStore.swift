import Foundation
import Observation

@MainActor @Observable
final class DashboardLayoutStore {
    private static let key = "ringLayout"

    private(set) var layout: DashboardLayout {
        didSet { save() }
    }

    init(layout: DashboardLayout? = nil) {
        var initial = layout ?? Self.load()
        if DebugLaunch.flag("resetLayout") { initial = .default }
        self.layout = initial
    }

    func setVisible(_ id: MetricID, _ visible: Bool) { layout.setVisible(id, visible) }
    func shiftRing(_ id: MetricID, by offset: Int) { layout.shift(id, by: offset) }

    private func save() {
        UserDefaults.standard.set(try? JSONEncoder().encode(layout), forKey: Self.key)
    }

    private static func load() -> DashboardLayout {
        guard let data = UserDefaults.standard.data(forKey: key),
              let stored = try? JSONDecoder().decode(DashboardLayout.self, from: data) else { return .default }
        return stored
    }
}
