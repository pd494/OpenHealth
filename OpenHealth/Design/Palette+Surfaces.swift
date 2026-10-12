import SwiftUI

extension Palette {
    static let hairline = Color.white.opacity(0.06)
    static let stitch = Color.white.opacity(0.14)
    /// Top-lit gradient laid over card fills.
    static let sheen = LinearGradient(colors: [.white.opacity(0.045), .clear], startPoint: .top, endPoint: .center)
    /// Card edge: bright where light catches the top, fading out toward the bottom.
    static let rim = LinearGradient(colors: [.white.opacity(0.13), .white.opacity(0.03)], startPoint: .top, endPoint: .bottom)
    /// Recessed groove behind ring and bar progress.
    static let groove = Color.black.opacity(0.35)
}
