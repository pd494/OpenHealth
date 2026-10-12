import SwiftUI

struct RingCell: View {
    @Environment(HealthManager.self) private var health

    let metric: MetricID
    let isEditing: Bool

    var body: some View {
        MetricRingView(value: health.value(metric))
            .overlay(alignment: .topLeading) {
                if isEditing { HideBadge(metric: metric).scaleEffect(0.8).offset(x: -4, y: -4) }
            }
            .overlay(alignment: .topTrailing) {
                if isEditing { StyleBadge(metric: metric, style: .tile).offset(x: 4, y: -4) }
            }
            .contextMenu { TileContextMenu(metric: metric, style: .ring) }
    }
}
