import SwiftUI

/// A metric that isn't a ring, icon and name, then the number beside a half dial toward the goal.
struct MetricPill: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var typeSize

    let metric: MetricDescriptor

    /// The dark label colour reads on a light card; on a dark card it needs the bright ring colour.
    private var labelColor: Color {
        colorScheme == .dark ? metric.domain.ringStart : metric.domain.ringLabel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: metric.symbol)
                    .font(.system(size: 12, weight: .semibold))
                    .accessibilityHidden(true)
                Text(metric.title)
                    .font(.caption.weight(.medium))
                    .lineLimit(typeSize.isAccessibilitySize ? nil : 1)
            }
            .foregroundStyle(labelColor)
            HStack(alignment: .bottom, spacing: 8) {
                Text("\(metric.number)\(Text(metric.unitSuffix).font(.system(.caption, weight: .regular)).foregroundStyle(.secondary))")
                    .font(.system(.headline, weight: .bold))
                    .tracking(-0.2)
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .lineLimit(typeSize.isAccessibilitySize ? nil : 1)
                    .layoutPriority(1)
                Spacer(minLength: 0)
                if !typeSize.isAccessibilitySize { chart }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(metric.title), \(metric.valueText)")
        .accessibilityValue(metric.hasGoal ? "\(Int((metric.progress * 100).rounded())) percent of goal" : "")
    }

    /// Placeholder weeks of history until real data is wired in.
    @ViewBuilder private var chart: some View {
        let tint = metric.domain.ringStart, soft = metric.domain.ringEnd, deep = metric.domain.ringDeep
        switch metric.id {
        case .floors: MiniBars(values: [6, 2, 9, 4, 11, 5, 3], tint: tint, softTint: soft, deepTint: deep)
        case .exerciseDays: MiniBars(values: [1, 0, 1, 1, 0, 1, 0], tint: tint, softTint: soft, deepTint: deep)
        case .netCalories: MiniWave(values: [-210, -380, 120, -462, -150, -300, -462], tint: tint, softTint: soft, deepTint: deep)
        case .hrv: MiniWave(values: [62, 68, 59, 74, 66, 79, 71], tint: tint, softTint: soft, deepTint: deep)
        case .restingHeartRate: MiniWave(values: [54, 53, 55, 52, 53, 51, 51], tint: tint, softTint: soft, deepTint: deep)
        case .heartRate: MiniWave(values: [72, 64, 81, 69, 75, 63, 68], tint: tint, softTint: soft, deepTint: deep)
        case .weight: MiniWave(values: [142.4, 142.0, 141.8, 141.5, 141.3, 141.0, 140.8], tint: tint, softTint: soft, deepTint: deep)
        case _ where metric.hasGoal: HalfDial(progress: metric.progress, tint: tint, softTint: soft, deepTint: deep)
        default: MiniWave(values: [1, 1, 1, 1, 1, 1, 1], tint: tint, softTint: soft, deepTint: deep)
        }
    }
}

#Preview {
    VStack {
        MetricPill(metric: MetricID.hydration.descriptor)
        MetricPill(metric: MetricID.restingHeartRate.descriptor)
    }
    .padding()
    .background(Palette.card)
}
