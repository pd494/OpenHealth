import SwiftUI

struct TodaySettingsMenu: View {
    @Environment(DashboardLayoutStore.self) private var store
    @Binding var sheet: TodaySheet?

    var body: some View {
        Menu {
            Button("Edit goals", systemImage: "slider.horizontal.3") { sheet = .goals }
            Button(store.layout.ringDetailsCollapsed ? "Show overview details" : "Hide overview details", systemImage: "list.bullet") { store.toggleRingDetails() }
            Picker("Rings", selection: Binding(get: { store.layout.ringsMode }, set: store.setRingsMode)) {
                ForEach(RingsMode.allCases) { Text($0.title).tag($0) }
            }
            Picker("Tiles", selection: Binding(get: { store.layout.tileLayout }, set: store.setTileLayout)) {
                ForEach(TileLayout.allCases) { Text($0.title).tag($0) }
            }
            Picker("Cal burned", selection: Binding(get: { store.layout.calories }, set: store.setCalories)) {
                ForEach(CaloriePreference.allCases) { Text($0.title).tag($0) }
            }
        } label: {
            Label("Layout", systemImage: "slider.horizontal.3")
                .labelStyle(.iconOnly)
                .font(.subheadline.weight(.semibold))
                .frame(width: Layout.minTapTarget, height: Layout.minTapTarget)
        }
    }
}
