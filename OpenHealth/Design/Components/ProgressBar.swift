import SwiftUI

struct ProgressBar: View {
    let ratio: Double
    let tint: Color
    static let defaultHeight = 4.0
    var height = Self.defaultHeight

    var body: some View {
        AnimatedProgress(ratio: ratio) { displayed in
            Capsule()
                .fill(Palette.groove)
                .frame(height: height)
                .overlay(alignment: .leading) {
                    GeometryReader { proxy in
                        Capsule().fill(LinearGradient(colors: [tint.opacity(0.7), tint], startPoint: .leading, endPoint: .trailing)).frame(width: proxy.size.width * min(max(displayed, 0), 1))
                    }
                }
        }
        .accessibilityHidden(true)
    }
}
