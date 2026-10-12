import SwiftUI

struct SleepSummaryCard: View {
    let value: MetricValue
    let night: SleepNight?

    var body: some View {
        HStack(spacing: 22) {
            RingGauge(value: value, size: 112)
            VStack(alignment: .leading, spacing: 6) {
                Text("Time asleep").eyebrow()
                Text(value.number).metricNumber(.largeTitle, weight: .bold).minimumScaleFactor(0.7).lineLimit(1)
                if let bed = night?.bedtime, let wake = night?.wakeTime {
                    Text("\(bed, format: .dateTime.hour().minute()) to \(wake, format: .dateTime.hour().minute())")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Text(value.goalText.map { "\($0) goal" } ?? "").font(.caption).foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
        }
        .card()
        .accessibilityElement(children: .combine)
    }
}
