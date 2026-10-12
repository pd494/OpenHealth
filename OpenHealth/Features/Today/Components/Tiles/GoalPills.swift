import SwiftUI

/// Metrics pinned into the Goals card, two per row under the rings.
struct GoalPills: View {
    @Environment(HealthManager.self) private var health
    @ScaledMetric(relativeTo: .body) private var height = Layout.pillTileHeight

    let pills: [DashboardItem]
    let isEditing: Bool
    var onSelect: (MetricID) -> Void = { _ in }

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: Layout.tileSpacing), count: 2), spacing: Layout.tileSpacing) {
            ForEach(pills) { item in
                Button { onSelect(item.metric) } label: {
                    MetricPill(value: health.value(item.metric), showsHandle: false)
                        .frame(height: height)
                }
                .buttonStyle(.pressable)
                .overlay(alignment: .topLeading) {
                    if isEditing { HideBadge(metric: item.metric).scaleEffect(0.8).offset(x: -10, y: -10) }
                }
                .contextMenu { TileContextMenu(metric: item.metric, style: .pill) }
            }
        }
    }
}
