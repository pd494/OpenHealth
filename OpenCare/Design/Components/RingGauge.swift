import SwiftUI

struct RingGauge: View {
    let value: MetricValue
    var size = Layout.ringSize

    private var descriptor: MetricDescriptor { value.id.descriptor }
    private var isLarge: Bool { size > 80 }

    var text: String { descriptor.format == .percent && value.value != nil ? value.number + "%" : value.number }

    var body: some View {
        ZStack {
            ProgressRing(ratio: value.progress ?? 0, lineWidth: isLarge ? Layout.ringLineWidth : 6, tint: descriptor.tint)
            VStack(spacing: 2) {
                if isLarge {
                    Image(systemName: descriptor.symbol)
                        .font(.caption)
                        .foregroundStyle(descriptor.tint)
                        .accessibilityHidden(true)
                }
                Text(text)
                    .metricNumber(isLarge ? (text.count > 5 ? .subheadline : .title3) : .caption, weight: .bold)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
            }
            .padding(.horizontal, isLarge ? 10 : 6)
        }
        .frame(width: size, height: size)
    }
}
