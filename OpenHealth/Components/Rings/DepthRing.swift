import SwiftUI

/// Progress ring with a lightly tinted track and a gradient that deepens toward the rounded active end.
struct DepthRing: View {
    let ratio: Double
    let lineWidth: Double
    let tint: Color
    let softTint: Color
    let deepTint: Color

    private var clamped: Double { min(max(ratio, 0), 1) }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Palette.card, lineWidth: lineWidth * 0.9)
                .scaleEffect(1.1)
                .shadow(color: .black.opacity(0.12), radius: 3, y: 1.5)
            Circle().stroke(tint.opacity(0.18), lineWidth: lineWidth * 1.15)
            Circle()
                .trim(from: 0, to: clamped)
                .stroke(
                    AngularGradient(
                        colors: [softTint, tint, deepTint],
                        center: .center, startAngle: .zero, endAngle: .degrees(360 * max(clamped, 0.01))
                    ),
                    style: StrokeStyle(lineWidth: lineWidth * 1.4, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
        }
        .padding(lineWidth / 2)
        .accessibilityHidden(true)
    }
}
