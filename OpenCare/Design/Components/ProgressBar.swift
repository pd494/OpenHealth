import SwiftUI

struct ProgressBar: View {
    let ratio: Double
    let tint: Color

    var body: some View {
        Capsule()
            .fill(Palette.track)
            .frame(height: 4)
            .overlay(alignment: .leading) {
                GeometryReader { proxy in
                    Capsule().fill(tint).frame(width: proxy.size.width * min(max(ratio, 0), 1))
                }
            }
            .accessibilityHidden(true)
    }
}
