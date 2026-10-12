import SwiftUI

struct TileGrid: View {
    @Environment(HealthManager.self) private var health
    @Environment(DashboardLayoutStore.self) private var store
    @Environment(\.dynamicTypeSize) private var typeSize
    @ScaledMetric(relativeTo: .title) private var gridHeight = Layout.gridTileHeight
    @ScaledMetric(relativeTo: .body) private var listHeight = Layout.listTileHeight
    @ScaledMetric(relativeTo: .body) private var pillHeight = Layout.pillTileHeight

    let isEditing: Bool
    let onSelect: (MetricID) -> Void

    private var tileLayout: TileLayout { typeSize.isAccessibilitySize ? .list : store.layout.tileLayout }

    private var rowHeight: Double {
        switch tileLayout {
        case .pills: pillHeight
        case .grid: gridHeight
        case .list: listHeight
        }
    }

    var body: some View {
        ReorderableGrid(
            items: store.layout.tiles,
            columns: tileLayout.columns,
            rowHeight: rowHeight,
            onMove: store.moveTile
        ) { item in
            Button { onSelect(item.metric) } label: {
                if tileLayout == .pills {
                    MetricPill(value: health.value(item.metric))
                } else {
                    MetricTile(value: health.value(item.metric), layout: tileLayout)
                }
            }
            .buttonStyle(.pressable)
            .overlay(alignment: .topLeading) {
                if isEditing { HideBadge(metric: item.metric) }
            }
            .overlay(alignment: .bottomTrailing) {
                if isEditing && item.metric.descriptor.supportsGoal {
                    StyleBadge(metric: item.metric, style: .ring).offset(x: 6, y: 6)
                }
            }
            .contextMenu { TileContextMenu(metric: item.metric, style: .tile) }
        }
    }
}
