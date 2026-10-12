import SwiftUI

struct RingsRows: View {
    @Environment(HealthManager.self) private var health

    let rings: [DashboardItem]
    let isEditing: Bool
    let showsDetails: Bool
    var pills: [DashboardItem] = []
    var onSelect: (MetricID) -> Void = { _ in }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            RingFlowLayout {
                ForEach(Array(rings.enumerated()), id: \.element.id) { index, item in
                    RingCell(metric: item.metric, isEditing: isEditing)
                        .environment(\.fillDelay, Double(index) * RingsSection.ringStagger)
                }
            }
            if !pills.isEmpty { GoalPills(pills: pills, isEditing: isEditing, onSelect: onSelect) }
            if showsDetails {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(rings) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            Label(item.metric.descriptor.title, systemImage: item.metric.descriptor.symbol)
                                .cardTitle()
                                .labelStyle(DetailLabelStyle(tint: item.metric.descriptor.tint))
                            HStack(spacing: 8) {
                                ForEach(health.stats(for: item.metric, hiding: rings.map(\.metric))) { MiniStat(stat: $0) }
                            }
                        }
                    }
                }
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
