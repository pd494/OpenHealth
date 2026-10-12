import SwiftUI

struct RingGauge: View {
    let value: MetricValue
    /// Fixed diameter, or nil to fill the available width up to `Layout.ringSize`.
    var size: Double?
    var centerText: String?

    private var descriptor: MetricDescriptor { value.id.descriptor }
    private var isLarge: Bool { (size ?? Layout.ringSize) > 64 }

    var text: String { centerText ?? (descriptor.format == .percent && value.value != nil ? value.number + "%" : value.number) }

    var body: some View {
        ZStack {
            AnimatedProgress(ratio: value.progress ?? 0) {
                DepthRing(ratio: $0, lineWidth: isLarge ? Layout.ringLineWidth : 6, tint: descriptor.tint)
            }
            Text(text)
                .metricNumber(isLarge ? (text.count > 5 ? .subheadline : .headline) : .caption2, weight: .semibold)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
                .padding(.horizontal, isLarge ? 14 : 8)
        }
        .frame(maxWidth: size ?? Layout.ringSize, maxHeight: size ?? Layout.ringSize)
        .aspectRatio(1, contentMode: .fit)
    }
}
