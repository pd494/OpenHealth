import SwiftUI

struct RingsRows: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    @Environment(HealthManager.self) private var health

    let rings: [DashboardItem]
    let isEditing: Bool
    let showsDetails: Bool
    var onSelect: (MetricID) -> Void = { _ in }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            RingFlowLayout(maxPerRow: typeSize.isAccessibilitySize ? 1 : 3, spacing: 4) {
                ForEach(Array(rings.enumerated()), id: \.element.id) { index, item in
                    RingCell(metric: item.metric, isEditing: isEditing, onSelect: onSelect)
                        .environment(\.fillDelay, Double(index) * RingsSection.ringStagger)
                }
            }
            if showsDetails {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(rings) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            Label(item.metric.descriptor.title, systemImage: item.metric.descriptor.symbol)
                                .cardTitle()
                                .labelStyle(DetailLabelStyle(tint: item.metric.descriptor.tint))
                            let statsLayout = typeSize.isAccessibilitySize
                                ? AnyLayout(VStackLayout(alignment: .leading, spacing: 8))
                                : AnyLayout(HStackLayout(spacing: 8))
                            statsLayout {
                                ForEach(health.stats(for: item.metric, hiding: rings.map(\.metric))) { MiniStat(stat: $0) }
                            }
                        }
                    }
                }
                .card()
                .softLift()
            }
        }
    }
}

private struct DetailLabelStyle: LabelStyle {
    let tint: Color

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 6) {
            configuration.icon.foregroundStyle(tint)
            configuration.title
        }
    }
}
