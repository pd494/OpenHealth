import SwiftUI

struct ProgressBar: View {
    let ratio: Double
    let tint: Color
    var height = 3.0

    var body: some View {
        AnimatedProgress(ratio: ratio) { displayed in
            Capsule()
                .fill(Palette.track)
                .frame(height: height)
                .overlay(alignment: .leading) {
                    GeometryReader { proxy in
                        Capsule().fill(tint).frame(width: proxy.size.width * min(max(displayed, 0), 1))
                    }
                }
        }
        .accessibilityHidden(true)
    }
}
