import SwiftUI

/// Big rounded number with a small caption beneath, sized from the ring's diameter so it always fits the inner circle.
struct RingCenterLabel: View {
    let number: String
    /// Small unit kept on the number's line, such as "%".
    let suffix: String?
    let caption: String?
    let captionColor: Color
    let diameter: Double

    var body: some View {
        VStack(spacing: diameter * 0.01) {
            Text("\(number)\(Text(suffix ?? "").font(.system(size: diameter * 0.1, weight: .regular, design: .rounded)).foregroundStyle(.secondary))")
                .font(.system(size: diameter * 0.18, weight: .bold, design: .rounded))
                .monospacedDigit()
                .tracking(-diameter * 0.003)
                .lineLimit(1)
                .minimumScaleFactor(1)
            if let caption {
                Text(caption)
                    .font(.system(size: diameter * 0.065, weight: .regular, design: .rounded))
                    .textCase(.uppercase)
                    .tracking(diameter * 0.006)
                    .foregroundStyle(captionColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
        }
        .frame(width: diameter * 0.72)
    }
}
