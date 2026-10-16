import SwiftUI

/// A round-capped arc that eases up to `ratio` over a faint track, starting at 12 o'clock.
struct ProgressRing: View {
    let ratio: Double
    let lineWidth: Double
    let tint: Color

    var body: some View {
        AnimatedProgress(ratio: min(max(ratio, 0), 1)) { shown in
            Circle()
                .stroke(tint.opacity(0.18), lineWidth: lineWidth)
                .overlay {
                    Circle()
                        .trim(from: 0, to: max(shown, 0.01))
                        .stroke(tint, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                }
        }
    }
}

#Preview {
    ProgressRing(ratio: 0.7, lineWidth: 8, tint: MetricDomain.sleep.ringStart)
        .frame(width: 96, height: 96)
        .padding()
}
