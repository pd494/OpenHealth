import SwiftUI

struct CalorieSummaryCard: View {
    @Environment(\.dynamicTypeSize) private var typeSize

    private let eaten = MetricID.caloriesIn.descriptor
    private let burned = MetricID.activeEnergy.descriptor

    private var remaining: Int { Int(eaten.goal - eaten.value) }

    var body: some View {
        VStack(spacing: 20) {
            ViewThatFits {
                HStack(spacing: 24) {
                    ring
                    totals
                }
                VStack(spacing: 16) {
                    ring
                    totals
                }
            }
            macros
        }
        .padding(Layout.cardPadding)
        .frame(maxWidth: .infinity)
        .surface()
    }

    private var ring: some View {
        ProgressRing(ratio: eaten.progress, lineWidth: 8, tint: MetricDomain.nutrition.ringStart)
            .overlay {
                VStack(spacing: 0) {
                    Text(remaining, format: .number)
                        .font(.title2.weight(.heavy))
                        .monospacedDigit()
                    Text("left")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 96, height: 96)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Calories left")
            .accessibilityValue("\(remaining) of \(eaten.goalText)")
    }

    private var totals: some View {
        VStack(alignment: .leading, spacing: 8) {
            total("Eaten", eaten.valueText)
            total("Goal", eaten.goalText)
            total("Burned", burned.valueText)
        }
    }

    @ViewBuilder private var macros: some View {
        if typeSize.isAccessibilitySize {
            VStack(spacing: 12) { macroRows }
        } else {
            HStack(spacing: 12) { macroRows }
        }
    }

    private var macroRows: some View {
        ForEach(Macro.allCases, id: \.self) { MacroProgress(macro: $0) }
    }

    private func total(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline.bold())
                .monospacedDigit()
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    CalorieSummaryCard()
        .padding()
        .background(Palette.background)
}
