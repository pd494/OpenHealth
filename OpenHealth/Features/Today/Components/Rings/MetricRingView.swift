import SwiftUI

struct MetricRingView: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    let value: MetricValue

    private var descriptor: MetricDescriptor { value.id.descriptor }
    private var caption: String { value.goalTextWithUnit ?? value.subtitle ?? "No data" }

    var body: some View {
        Group {
            if typeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: 8) {
                    Text(descriptor.title).font(.headline)
                    Text(RingGauge(value: value).text).font(.title2).monospacedDigit()
                    Text(caption).font(.caption).foregroundStyle(.secondary)
                    if let progress = value.progress {
                        ProgressView(value: min(max(progress, 0), 1))
                            .tint(descriptor.tint)
                            .accessibilityHidden(true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                VStack(spacing: 8) {
                    RingGauge(value: value)
                    Text(descriptor.title)
                        .font(.footnote.weight(.semibold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(descriptor.title), \(RingGauge(value: value).text), \(caption)")
    }
}

#Preview {
    HStack {
        MetricRingView(value: MetricValue(id: .steps, value: 6_428, goal: 10_000, subtitle: nil))
        MetricRingView(value: MetricValue(id: .recovery, value: nil, goal: 100, subtitle: nil))
    }
    .padding()
    .background(Palette.background)
}
