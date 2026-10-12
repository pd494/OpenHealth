import SwiftUI

struct ProgressBar: View {
    let ratio: Double
    let tint: Color
    static let defaultHeight = 4.0
    var height = Self.defaultHeight

    var body: some View {
        AnimatedProgress(ratio: ratio) { displayed in
            Capsule()
                .fill(Palette.groove.shadow(.inner(color: .black.opacity(0.12), radius: 1, y: 1)))
                .frame(height: height)
                .overlay(alignment: .leading) {
                    GeometryReader { proxy in
                        Capsule()
                            .fill(LinearGradient(colors: [tint.opacity(0.75), tint], startPoint: .leading, endPoint: .trailing))
                            .overlay(alignment: .top) { Capsule().fill(.white.opacity(0.25)).frame(height: height / 2).padding(.horizontal, height / 2) }
                            .shadow(color: tint.opacity(0.4), radius: height / 2)
                            .frame(width: proxy.size.width * min(max(displayed, 0), 1))
                    }
                }
        }
        .accessibilityHidden(true)
    }
}
