import SwiftUI

/// A ring with its supporting figures listed beside it as label/value lines.
struct RingStatsRow: View {
    @Environment(HealthManager.self) private var health
    @Environment(DashboardLayoutStore.self) private var store

    let metric: MetricID
    let isEditing: Bool
    let ringSize: Double

    var body: some View {
        let value = health.value(metric)
        HStack(alignment: .center, spacing: 20) {
            RingGauge(value: value, size: ringSize)
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .firstTextBaseline) {
                    Text(metric.descriptor.title).font(.rounded(.headline))
                    Spacer()
                    Text(value.goalTextWithUnit ?? "").font(.footnote).foregroundStyle(.secondary)
                }
                .padding(.bottom, 6)
                ForEach(Array(health.stats(for: metric, hiding: store.layout.rings.map(\.metric)).enumerated()), id: \.element.id) { index, stat in
                    Hairline()
                    HStack {
                        Text(stat.label).foregroundStyle(.secondary)
                        Spacer()
                        Text(stat.value).metricNumber(.subheadline)
                    }
                    .font(.subheadline)
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
