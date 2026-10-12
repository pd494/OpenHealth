import SwiftUI

struct ProgressRing: View {
    let ratio: Double
    var lineWidth = 8.0

    var body: some View {
        ZStack {
            Circle().stroke(Palette.track, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: min(max(ratio, 0), 1))
                .stroke(Palette.progress(ratio), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .accessibilityHidden(true)
    }
}
