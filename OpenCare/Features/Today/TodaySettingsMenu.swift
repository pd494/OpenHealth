import SwiftUI

struct TodaySettingsMenu: View {
    @Environment(DashboardLayoutStore.self) private var store

    var body: some View {
        Menu {
            Picker("Tiles", selection: Binding(get: { store.layout.tileLayout }, set: store.setTileLayout)) {
                ForEach(TileLayout.allCases) { Text($0.title).tag($0) }
            }
            Picker("Cal burned", selection: Binding(get: { store.layout.calories }, set: store.setCalories)) {
                ForEach(CaloriePreference.allCases) { Text($0.title).tag($0) }
            }
        } label: {
            Label("Layout", systemImage: "ellipsis")
                .iconOnlyButton()
                .font(.title3)
                .background(Palette.card, in: .circle)
        }
    }
}
