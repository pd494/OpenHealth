import SwiftUI

struct RingsRows: View {
    @Environment(HealthManager.self) private var health

    let rings: [DashboardItem]
    let isEditing: Bool
    let showsDetails: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            RingFlowLayout {
                ForEach(rings) { RingCell(metric: $0.metric, isEditing: isEditing) }
            }
            if showsDetails {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(rings) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            Label(item.metric.descriptor.title, systemImage: item.metric.descriptor.symbol)
                                .font(.caption2.weight(.semibold))
                                .textCase(.uppercase)
                                .tracking(0.6)
                                .foregroundStyle(.secondary)
                                .labelStyle(DetailLabelStyle(tint: item.metric.descriptor.tint))
                            HStack(spacing: 8) {
                                ForEach(health.stats(for: item.metric)) { MiniStat(stat: $0) }
                            }
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
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
