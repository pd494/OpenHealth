import SwiftUI

struct WaterCard: View {
    @Environment(\.presentLog) private var presentLog

    private let water = MetricID.hydration.descriptor

    var body: some View {
        HStack(spacing: 12) {
            MealIconTile(symbol: water.symbol)
            VStack(alignment: .leading, spacing: 8) {
                Text("Water")
                    .font(.subheadline.bold())
                ProgressBar(ratio: water.progress, tint: water.domain.ringStart)
            }
            Text("\(water.number) / \(water.goalText)")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .monospacedDigit()
            Button("Add water", systemImage: "plus") {
                presentLog(.water)
            }
            .labelStyle(.iconOnly)
            .frame(minWidth: Layout.minTapTarget, minHeight: Layout.minTapTarget)
        }
        .padding(Layout.cardPadding)
        .surface()
        .accessibilityElement(children: .contain)
    }
}

#Preview {
    WaterCard()
        .padding()
        .background(Palette.background)
}
