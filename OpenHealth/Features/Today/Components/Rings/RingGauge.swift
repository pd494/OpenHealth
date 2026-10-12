import SwiftUI

struct RingGauge: View {
    let value: MetricValue
    /// Fixed diameter, or nil to fill the available width up to `Layout.ringSize`.
    var size: Double?
    var centerText: String?

    private var descriptor: MetricDescriptor { value.id.descriptor }
    private var isLarge: Bool { (size ?? Layout.ringSize) > 64 }

    var text: String {
        if let centerText { return centerText }
        if descriptor.format == .percent && value.value != nil { return value.number + "%" }
        if !value.unit.isEmpty && value.unit != "steps" { return "\(value.number) \(value.unit)" }
        return value.number
    }

    var body: some View {
        ZStack {
            if let progress = value.progress {
                AnimatedProgress(ratio: progress) {
                    DepthRing(ratio: $0, lineWidth: isLarge ? Layout.ringLineWidth : 4, tint: descriptor.tint)
                }
            } else {
                Circle().stroke(descriptor.tint.opacity(0.4), lineWidth: 4).padding(2)
            }
            Text(text)
                .metricNumber(isLarge ? (text.count > 5 ? .subheadline : .headline) : .caption2, weight: .semibold)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
                .padding(.horizontal, isLarge ? 18 : 8)
        }
        .frame(maxWidth: size ?? Layout.ringSize, maxHeight: size ?? Layout.ringSize)
        .aspectRatio(1, contentMode: .fit)
    }
}
