import SwiftUI

struct FitnessStatPair: View {
    @Environment(\.dynamicTypeSize) private var typeSize

    private static let stats: [(metric: MetricID, title: String, trend: String, symbol: String, tint: Color)] = [
        (.activeZoneMinutes, "Active zone", "Above usual", "arrowtriangle.up.fill", .green),
        (.weeklyCardio, "Cardio load", "Below target", "arrowtriangle.down.fill", .orange),
    ]

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 12), count: typeSize.isAccessibilitySize ? 1 : 2)
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(Self.stats, id: \.metric) { stat in
                NavigationLink(value: stat.metric) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(stat.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Text(stat.metric.descriptor.valueText)
                            .font(.title2.weight(.bold))
                            .foregroundStyle(.primary)
                        Label(stat.trend, systemImage: stat.symbol)
                            .font(.caption)
                            .foregroundStyle(stat.tint)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(Layout.cardPadding)
                    .surface()
                    .accessibilityElement(children: .combine)
                }
                .buttonStyle(PressableButtonStyle())
            }
        }
    }
}

#Preview {
    NavigationStack { FitnessStatPair().padding().pageBackground() }
}
