import SwiftUI

struct RingsExpandedRow: View {
    @Environment(HealthManager.self) private var health

    let metric: MetricID
    let isEditing: Bool

    var body: some View {
        let value = health.value(metric)
        HStack(alignment: .center, spacing: 18) {
            VStack(spacing: 6) {
                RingGauge(value: value, size: 104)
                Text(metric.descriptor.title).font(.subheadline.weight(.medium))
            }
            VStack(spacing: 0) {
                ForEach(Array(health.stats(for: metric).enumerated()), id: \.element.id) { index, stat in
                    if index > 0 { Hairline() }
                    HStack {
                        Text(stat.label).font(.subheadline).foregroundStyle(.secondary)
                        Spacer()
                        Text(stat.value).metricNumber(.subheadline)
                    }
                    .padding(.vertical, 9)
                }
            }
            .accessibilityElement(children: .contain)
        }
        .overlay(alignment: .topLeading) {
            if isEditing { HideBadge(metric: metric).scaleEffect(0.8).offset(x: -14, y: -14) }
        }
        .overlay(alignment: .topTrailing) {
            if isEditing { StyleBadge(metric: metric, style: .tile).offset(x: 14, y: -14) }
        }
        .contextMenu { TileContextMenu(metric: metric, style: .ring) }
    }
}
