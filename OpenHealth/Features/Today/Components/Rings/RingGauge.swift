import SwiftUI

struct RingGauge: View {
    let metric: MetricDescriptor

    private var isPercent: Bool { metric.format == .percent }

    var text: String {
        if isPercent { return metric.number + "%" }
        if !metric.unit.isEmpty && metric.unit != "steps" { return "\(metric.number) \(metric.unit)" }
        return metric.number
    }

    var body: some View {
        GeometryReader { proxy in
            let diameter = min(proxy.size.width, proxy.size.height)
            let isLarge = diameter > 64
            ZStack {
                AnimatedProgress(ratio: metric.progress) {
                    DepthRing(ratio: $0, lineWidth: isLarge ? diameter * 0.085 : 4, tint: metric.domain.ringStart, softTint: metric.domain.ringEnd)
                }
                if isLarge {
                    RingCenterLabel(number: metric.number, suffix: isPercent ? "%" : nil, caption: metric.goalText, captionColor: metric.domain.ringLabel, diameter: diameter)
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
        .frame(maxWidth: Layout.ringSize, maxHeight: Layout.ringSize)
        .aspectRatio(1, contentMode: .fit)
    }
}
