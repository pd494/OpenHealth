import SwiftUI

extension Font {
    static func rounded(_ style: TextStyle, weight: Weight = .semibold) -> Font {
        .system(style, design: .rounded, weight: weight)
    }

    /// A fixed-size rounded font, for widget layouts that can't reflow.
    static func rounded(size: Double, weight: Weight = .semibold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}
