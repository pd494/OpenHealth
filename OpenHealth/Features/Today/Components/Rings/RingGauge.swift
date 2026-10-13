import SwiftUI

struct RingGauge: View {
    let value: MetricValue
    /// Fixed diameter, or nil to fill the available width up to `Layout.ringSize`.
    var size: Double?
    var centerText: String?

    private var descriptor: MetricDescriptor { value.id.descriptor }

    var text: String {
        if let centerText { return centerText }
        if descriptor.format == .percent && value.value != nil { return value.number + "%" }
        if !value.unit.isEmpty && value.unit != "steps" { return "\(value.number) \(value.unit)" }
        return value.number
    }

    private var isPercent: Bool { descriptor.format == .percent && value.value != nil }
    private var caption: String? { value.goalTextWithUnit ?? value.subtitle }

    var body: some View {
        GeometryReader { proxy in
            let diameter = min(proxy.size.width, proxy.size.height)
            let isLarge = diameter > 64
            let lineWidth = isLarge ? diameter * 0.085 : 4
            ZStack {
                if let progress = value.progress {
                    AnimatedProgress(ratio: progress) {
                        DepthRing(ratio: $0, lineWidth: lineWidth, tint: descriptor.domain.ringStart, softTint: descriptor.domain.ringEnd)
                    }
                } else {
                    Circle().stroke(descriptor.tint.opacity(0.4), style: StrokeStyle(lineWidth: 4, dash: [3, 7])).padding(2)
                }
                if isLarge {
                    RingCenterLabel(number: centerText ?? value.number, suffix: isPercent && centerText == nil ? "%" : nil, caption: centerText == nil ? caption : nil, captionColor: descriptor.domain.ringLabel, diameter: diameter)
                } else {
                    Text(text)
                        .font(.system(.caption2, design: .rounded, weight: .bold))
                        .monospacedDigit()
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                        .padding(.horizontal, 8)
                }
            }
            .frame(width: diameter, height: diameter)
        }
        .frame(maxWidth: size ?? Layout.ringSize, maxHeight: size ?? Layout.ringSize)
        .aspectRatio(1, contentMode: .fit)
    }
}
