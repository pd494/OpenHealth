import SwiftUI

struct TileGrid: View {
    @Environment(HealthManager.self) private var health
    @Environment(DashboardLayoutStore.self) private var store
    @Environment(\.dynamicTypeSize) private var typeSize
    @ScaledMetric(relativeTo: .title) private var gridHeight = Layout.gridTileHeight
    @ScaledMetric(relativeTo: .body) private var listHeight = Layout.listTileHeight

    let isEditing: Bool
    let onSelect: (MetricID) -> Void

    private var tileLayout: TileLayout { typeSize.isAccessibilitySize ? .list : store.layout.tileLayout }

    var body: some View {
        ReorderableGrid(
            items: store.layout.tiles,
            columns: tileLayout.columns,
            rowHeight: tileLayout == .grid ? gridHeight : listHeight,
            onMove: store.moveTile
        ) { item in
            Button { onSelect(item.metric) } label: {
                MetricTile(value: health.value(item.metric), layout: tileLayout)
            }
            .buttonStyle(.plain)
            .overlay(alignment: .topLeading) {
                if isEditing { HideBadge(metric: item.metric) }
            }
            .contextMenu { TileContextMenu(metric: item.metric) }
        }
    }
}
