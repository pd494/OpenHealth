import SwiftUI

struct RingCell: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    @Environment(HealthManager.self) private var health

    let metric: MetricID
    let isEditing: Bool
    var onSelect: (MetricID) -> Void = { _ in }

    var body: some View {
        Button { onSelect(metric) } label: {
            MetricRingView(value: health.value(metric))
                .padding(4)
                .contentShape(.rect)
        }
        .buttonStyle(.pressable)
        .overlay(alignment: .topLeading) {
            if isEditing { HideBadge(metric: metric).scaleEffect(0.8).offset(x: -4, y: -4) }
        }
        .overlay(alignment: .topTrailing) {
            if isEditing { StyleBadge(metric: metric, style: .tile).offset(x: 4, y: -4) }
        }
        .contextMenu { TileContextMenu(metric: metric, style: .ring) }
    }
}
