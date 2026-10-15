import SwiftUI

struct RingGauge: View {
    let metric: MetricDescriptor

    var body: some View {
        GeometryReader { proxy in
            let diameter = min(proxy.size.width, proxy.size.height)
            let isLarge = diameter > 64
            ZStack {
                AnimatedProgress(ratio: metric.progress) {
                    DepthRing(
                        ratio: $0, lineWidth: isLarge ? diameter * 0.085 : 4,
                        tint: metric.domain.ringStart, softTint: metric.domain.ringEnd, deepTint: metric.domain.ringDeep
                    )
                }
                if isLarge {
                    CenterLabel(number: metric.number, suffix: metric.ringSuffix, diameter: diameter)
                } else {
                    Text(metric.valueText)
                        .font(.system(.caption2, weight: .bold))
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

private struct CenterLabel: View {
    let number: String
    let suffix: String
    let diameter: Double

    /// Digits at full size; any letters, like the "h" and "m" of a duration, stay bold but step down in size.
    private var numberText: Text {
        var text = AttributedString(number)
        for index in text.characters.indices where text.characters[index].isLetter {
            let range = index..<text.characters.index(after: index)
            text[range].font = .system(size: diameter * 0.136, weight: .bold)
        }
        return Text(text)
    }

    var body: some View {
        Text("\(numberText)\(Text(suffix).bold())")
            .font(.system(size: diameter * 0.204, weight: .bold))
            .monospacedDigit()
            .tracking(-diameter * 0.003)
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .frame(width: diameter * 0.72)
    }
}
