import SwiftUI

struct MetricRingView: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    let metric: MetricDescriptor

    var body: some View {
        Group {
            if typeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: 8) {
                    Text(metric.title).font(.headline)
                    Text(RingGauge(metric: metric).text).font(.title2).monospacedDigit()
                    Text(metric.goalText).font(.caption).foregroundStyle(.secondary)
                    ProgressView(value: min(max(metric.progress, 0), 1))
                        .tint(metric.domain.ringStart)
                        .accessibilityHidden(true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                VStack(spacing: 8) {
                    RingGauge(metric: metric)
                    Text(metric.title)
                        .font(.footnote.weight(.semibold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(metric.title), \(RingGauge(metric: metric).text), \(metric.goalText)")
    }
}

#Preview {
    HStack {
        MetricRingView(metric: MetricID.steps.descriptor)
        MetricRingView(metric: MetricID.recovery.descriptor)
    }
    .padding()
    .background(Palette.background)
}
