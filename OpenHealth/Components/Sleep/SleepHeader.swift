import SwiftUI

struct SleepHeader: View {
    let night: SleepNight

    var body: some View {
        HStack(spacing: 12) {
            ProgressRing(ratio: night.goalProgress, lineWidth: 5, tint: MetricDomain.sleep.ringStart)
                .overlay { Text("🌙").font(.callout) }
                .padding(2.5)
                .frame(width: 44, height: 44)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text("Sleep")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(MetricDomain.sleep.adaptiveLabel)
                Text(SleepNight.duration(night.asleepMinutes))
                    .font(.system(.title, weight: .heavy))
                    .tracking(-0.5)
                Text("\(night.bedtime, format: .dateTime.hour().minute()) – \(night.wake, format: .dateTime.hour().minute())")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 8)
            VStack(alignment: .trailing, spacing: 8) {
                Text(night.score, format: .number)
                    .font(.system(.title2, weight: .heavy))
                    .foregroundStyle(MetricDomain.sleep.adaptiveLabel)
                Text(night.scoreLabel)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Sleep, \(SleepNight.duration(night.asleepMinutes)), score \(night.score), \(night.scoreLabel)")
    }
}
