import SwiftUI

/// App-side ring with a recessed groove and a lit, gradient arc.
/// The widget keeps the flat `ProgressRing`, which WidgetKit renders more predictably.
struct DepthRing: View {
    let ratio: Double
    let lineWidth: Double
    let tint: Color

    private var clamped: Double { min(max(ratio, 0), 1) }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Palette.groove, lineWidth: lineWidth)
                .overlay {
                    Circle()
                        .stroke(Palette.track.opacity(0.6), lineWidth: lineWidth)
                        .blur(radius: 0.5)
                }
            Circle()
                .trim(from: 0, to: clamped)
                .stroke(
                    AngularGradient(
                        colors: [tint.opacity(0.55), tint],
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360 * max(clamped, 0.01))
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: tint.opacity(0.35), radius: 4)
        }
        .padding(lineWidth / 2)
        .accessibilityHidden(true)
    }
}
