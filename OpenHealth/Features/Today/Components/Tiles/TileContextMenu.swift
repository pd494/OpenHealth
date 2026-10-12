import SwiftUI

struct TileContextMenu: View {
    @Environment(DashboardLayoutStore.self) private var store
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let metric: MetricID
    let style: DisplayStyle

    var body: some View {
        if style != .ring {
            Button("Show as ring", systemImage: "circle.dashed") { set(.ring) }
        }
        if style != .tile {
            Button("Move to tiles", systemImage: "square.grid.2x2") { set(.tile) }
        }
        if style != .tile {
            Section {
                Button("Move earlier", systemImage: "arrow.left") { shift(-1) }
                Button("Move later", systemImage: "arrow.right") { shift(1) }
            }
        }
        if DashboardLayout.canonical(metric) == .activeEnergy {
            Picker("Cal burned", selection: Binding(get: { store.layout.calories }, set: store.setCalories)) {
                ForEach(CaloriePreference.allCases) { Text($0.title).tag($0) }
            }
        }
        Button("Hide", systemImage: "eye.slash") { withMotion(reduceMotion: reduceMotion) { store.setVisible(metric, false) } }
    }

    private func set(_ newStyle: DisplayStyle) {
        withMotion(reduceMotion: reduceMotion) { store.setStyle(metric, newStyle) }
    }

    private func shift(_ offset: Int) {
        withMotion(reduceMotion: reduceMotion) {
            style == .ring ? store.shiftRing(metric, by: offset) : store.shiftPill(metric, by: offset)
        }
    }
}
