import SwiftUI

struct RingGauge: View {
    let value: MetricValue
    /// Fixed diameter, or nil to fill the available width up to `Layout.ringSize`.
    var size: Double?

    private var descriptor: MetricDescriptor { value.id.descriptor }
    private var isLarge: Bool { (size ?? Layout.ringSize) > 80 }

    var text: String { descriptor.format == .percent && value.value != nil ? value.number + "%" : value.number }

    var body: some View {
        ZStack {
            AnimatedProgress(ratio: value.progress ?? 0) {
                ProgressRing(ratio: $0, lineWidth: isLarge ? Layout.ringLineWidth : 6, tint: descriptor.tint)
            }
            VStack(spacing: 2) {
                if isLarge {
                    Image(systemName: descriptor.symbol)
                        .font(.caption)
                        .foregroundStyle(descriptor.tint)
                        .accessibilityHidden(true)
                }
                Text(text)
                    .metricNumber(isLarge ? (text.count > 5 ? .headline : .title2) : .caption, weight: .bold)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
            }
            .padding(.horizontal, isLarge ? 10 : 6)
        }
        .frame(maxWidth: size ?? Layout.ringSize, maxHeight: size ?? Layout.ringSize)
        .aspectRatio(1, contentMode: .fit)
    }
}
