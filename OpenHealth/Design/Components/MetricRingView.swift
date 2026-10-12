import SwiftUI

struct MetricRingView: View {
    let value: MetricValue

    private var descriptor: MetricDescriptor { value.id.descriptor }
    private var caption: String { value.goalText ?? value.subtitle ?? "No data" }

    var body: some View {
        VStack(spacing: 8) {
            RingGauge(value: value)
            VStack(spacing: 2) {
                Text(descriptor.title)
                    .font(.footnote.weight(.semibold))
                Text(caption)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
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
