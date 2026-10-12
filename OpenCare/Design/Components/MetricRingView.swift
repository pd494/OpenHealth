import SwiftUI

struct MetricRingView: View {
    let value: MetricValue

    private var descriptor: MetricDescriptor { value.id.descriptor }
    private var centerText: String { descriptor.format == .percent && value.value != nil ? value.number + "%" : value.number }

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                ProgressRing(ratio: value.progress ?? 0, lineWidth: Layout.ringLineWidth, tint: descriptor.tint)
                VStack(spacing: 2) {
                    Image(systemName: descriptor.symbol)
                        .font(.caption)
                        .foregroundStyle(descriptor.tint)
                        .accessibilityHidden(true)
                    Text(centerText)
                        .metricNumber(centerText.count > 5 ? .subheadline : .title3)
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                }
                .padding(.horizontal, 10)
            }
            .frame(width: Layout.ringSize, height: Layout.ringSize)
            VStack(spacing: 2) {
                Text(descriptor.title)
                    .font(.subheadline.weight(.medium))
                Text(value.goalText ?? value.subtitle ?? "No data")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(descriptor.title), \(centerText), \(value.goalText ?? value.subtitle ?? "no data")")
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
