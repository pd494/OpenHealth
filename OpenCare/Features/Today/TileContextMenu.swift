import SwiftUI

struct TileContextMenu: View {
    @Environment(DashboardLayoutStore.self) private var store

    let metric: MetricID

    var body: some View {
        if DashboardLayout.canonical(metric) == .activeEnergy {
            Picker("Cal burned", selection: Binding(get: { store.layout.calories }, set: store.setCalories)) {
                ForEach(CaloriePreference.allCases) { Text($0.title).tag($0) }
            }
        }
        Button("Hide", systemImage: "eye.slash") { store.setVisible(metric, false) }
    }
}
