import SwiftUI

struct TileGrid: View {
    @Environment(HealthManager.self) private var health
    @Environment(DashboardLayoutStore.self) private var store
    @Environment(\.dynamicTypeSize) private var typeSize
    @ScaledMetric(relativeTo: .title) private var gridHeight = Layout.gridTileHeight
    @ScaledMetric(relativeTo: .body) private var listHeight = Layout.listTileHeight

    let onSelect: (MetricID) -> Void

    private var tileLayout: TileLayout { typeSize.isAccessibilitySize ? .list : store.layout.tileLayout }

    var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: Layout.tileSpacing), count: tileLayout.columns),
            spacing: Layout.tileSpacing
        ) {
            ForEach(store.layout.tiles) { item in
                Button { onSelect(item.metric) } label: {
                    MetricTile(value: health.value(item.metric), layout: tileLayout)
                        .frame(height: tileLayout == .grid ? gridHeight : listHeight)
                }
                .buttonStyle(.plain)
                .contextMenu { TileContextMenu(metric: item.metric) }
            }
        }
        .animation(.snappy, value: store.layout.tiles)
    }
}
