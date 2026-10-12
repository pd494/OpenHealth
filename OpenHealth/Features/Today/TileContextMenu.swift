import SwiftUI

struct TileContextMenu: View {
    @Environment(DashboardLayoutStore.self) private var store
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let metric: MetricID
    let style: DisplayStyle

    var body: some View {
        if metric.descriptor.supportsGoal {
            Button(
                style == .tile ? "Show as ring" : "Show as tile",
                systemImage: style == .tile ? "circle.dashed" : "square.grid.2x2"
            ) {
                withMotion(reduceMotion: reduceMotion) { store.setStyle(metric, style == .tile ? .ring : .tile) }
            }
        }
        if style == .ring {
            Button("Move earlier", systemImage: "arrow.left") { withMotion(reduceMotion: reduceMotion) { store.shiftRing(metric, by: -1) } }
            Button("Move later", systemImage: "arrow.right") { withMotion(reduceMotion: reduceMotion) { store.shiftRing(metric, by: 1) } }
        }
        if DashboardLayout.canonical(metric) == .activeEnergy {
            Picker("Cal burned", selection: Binding(get: { store.layout.calories }, set: store.setCalories)) {
                ForEach(CaloriePreference.allCases) { Text($0.title).tag($0) }
            }
        }
        Button("Hide", systemImage: "eye.slash") { withMotion(reduceMotion: reduceMotion) { store.setVisible(metric, false) } }
    }
}
