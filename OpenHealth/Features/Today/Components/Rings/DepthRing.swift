import SwiftUI

/// Activity-style ring: tinted track, an angular gradient that deepens toward the head,
/// and a shadowed end cap so the leading edge reads as lifted once the ring laps itself.
struct DepthRing: View {
    let ratio: Double
    let lineWidth: Double
    let tint: Color

    private var clamped: Double { min(max(ratio, 0), 1) }

    var body: some View {
        ZStack {
            Circle().stroke(tint.opacity(0.22), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: clamped)
                .stroke(
                    AngularGradient(
                        colors: [tint.opacity(0.85), tint],
                        center: .center, startAngle: .zero, endAngle: .degrees(360 * max(clamped, 0.01))
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: tint.opacity(0.45), radius: lineWidth / 3)
            if clamped > 0 {
                GeometryReader { proxy in
                    Circle()
                        .fill(tint)
                        .frame(width: lineWidth, height: lineWidth)
                        .shadow(color: .black.opacity(0.35), radius: lineWidth / 3, x: lineWidth / 4)
                        .position(x: proxy.size.width / 2, y: 0)
                        .rotationEffect(.degrees(360 * clamped))
                }
            }
        }
        .padding(lineWidth / 2)
        .accessibilityHidden(true)
    }
}
