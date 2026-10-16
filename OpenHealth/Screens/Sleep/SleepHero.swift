import SwiftUI

struct SleepHero: View {
    @ScaledMetric(relativeTo: .largeTitle) private var ringSize = 120.0

    let night: SleepNight

    private static let lineWidth = 8.0

    private var goal: Double { MetricID.sleep.descriptor.goal }

    var body: some View {
        VStack(spacing: 12) {
            ring
            VStack(spacing: 4) {
                Text(SleepNight.duration(night.asleepMinutes))
                    .font(.system(.title, weight: .heavy))
                Text("\(night.bedtime, format: .dateTime.hour().minute()) – \(night.wake, format: .dateTime.hour().minute()) · \(night.goalProgress, format: .percent.precision(.fractionLength(0))) of your \(Int(goal))h goal")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(Layout.cardPadding)
        .frame(maxWidth: .infinity)
        .surface()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Sleep, \(SleepNight.duration(night.asleepMinutes)), score \(night.score), \(night.scoreLabel)")
        .accessibilityValue("\(Int((night.goalProgress * 100).rounded())) percent of your \(Int(goal)) hour goal")
    }

    private var ring: some View {
        ProgressRing(ratio: night.goalProgress, lineWidth: Self.lineWidth, tint: MetricDomain.sleep.ringStart)
            .padding(Self.lineWidth / 2)
            .frame(width: ringSize, height: ringSize)
            .overlay {
                VStack(spacing: 0) {
                    Text(night.score, format: .number)
                        .font(.system(.largeTitle, weight: .heavy))
                        .foregroundStyle(MetricDomain.sleep.adaptiveLabel)
                    Text(night.scoreLabel)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
    }
}

#Preview {
    SleepHero(night: .demo)
        .padding()
        .background(Palette.background)
}
