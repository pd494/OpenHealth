import SwiftUI

struct RingsBesideCell: View {
    @Environment(HealthManager.self) private var health

    let metric: MetricID
    let isEditing: Bool

    var body: some View {
        HStack(spacing: 12) {
            RingGauge(value: health.value(metric), size: 68)
            VStack(alignment: .leading, spacing: 3) {
                Text(metric.descriptor.title).font(.footnote.weight(.semibold))
                ForEach(health.stats(for: metric)) { stat in
                    Text("\(stat.label) \(Text(stat.value).foregroundStyle(Color.primary))")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
            }
        }
        .overlay(alignment: .topLeading) {
            if isEditing { HideBadge(metric: metric).scaleEffect(0.7).offset(x: -14, y: -14) }
        }
        .overlay(alignment: .topTrailing) {
            if isEditing { StyleBadge(metric: metric, style: .tile).scaleEffect(0.8) }
        }
        .contextMenu { TileContextMenu(metric: metric, style: .ring) }
    }
}
