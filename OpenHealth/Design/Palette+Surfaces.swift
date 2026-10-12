import SwiftUI

extension Palette {
    static let hairline = Color(.separator)
    static let stitch = Color(.separator)
    static let rim = Color(.separator)
    static let groove = Color(.tertiarySystemFill)

    /// Light on the top edge fading to nothing by the bottom — reads as a bevel without a visible outline.
    static let bevel = LinearGradient(
        colors: [.white.opacity(0.14), .white.opacity(0.02), .clear],
        startPoint: .top, endPoint: .bottom
    )
    static let contactShadow = Color.black.opacity(0.06)
    static let ambientShadow = Color.black.opacity(0.08)
}
