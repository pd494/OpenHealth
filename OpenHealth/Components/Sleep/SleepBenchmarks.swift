import SwiftUI

/// Each stage's share of the night, drawn against the range typical for adults.
struct SleepBenchmarks: View {
    let night: SleepNight

    private static let stages: [SleepStage] = [.deep, .rem, .core]

    var body: some View {
        VStack(spacing: 16) {
            ForEach(Self.stages, id: \.self) { stage in
                BenchmarkRow(stage: stage, share: night.share(of: stage))
            }
        }
    }
}

private struct BenchmarkRow: View {
    let stage: SleepStage
    let share: Double

    private var range: ClosedRange<Double> { stage.typicalShare! }
    private var status: String {
        share < range.lowerBound ? "Below range" : share > range.upperBound ? "Above range" : "In range"
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Text(stage.title).font(.footnote.weight(.semibold))
                Spacer()
                Text(share, format: .percent.precision(.fractionLength(0)))
                    .font(.footnote.weight(.bold))
                    .monospacedDigit()
                    .foregroundStyle(stage.fill)
                Text(status)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            ShareBar(share: share, range: range, tint: stage.fill)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(stage.title)
        .accessibilityValue("\(share.formatted(.percent.precision(.fractionLength(0)))) of sleep, \(status)")
    }
}

/// A track scaled to 60% of the night, with the typical band shaded and a pin where this night landed.
private struct ShareBar: View {
    let share: Double
    let range: ClosedRange<Double>
    let tint: Color

    private static let ceiling = 0.6
    private static let height = 14.0

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            ZStack(alignment: .leading) {
                Capsule().fill(Palette.sleepTray).frame(height: 8)
                Capsule()
                    .fill(tint.opacity(0.28))
                    .frame(width: (range.upperBound - range.lowerBound) / Self.ceiling * width, height: 8)
                    .offset(x: range.lowerBound / Self.ceiling * width)
                Capsule()
                    .fill(tint)
                    .frame(width: 4, height: Self.height)
                    .overlay { Capsule().stroke(Palette.card, lineWidth: 1.5) }
                    .offset(x: min(share / Self.ceiling, 1) * width - 2)
            }
            .frame(height: Self.height)
        }
        .frame(height: Self.height)
        .accessibilityHidden(true)
    }
}
