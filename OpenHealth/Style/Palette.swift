import SwiftUI

enum Palette {
    static let background = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? .black
            : UIColor(red: 0.955, green: 0.96, blue: 0.97, alpha: 1)
    })
    static let card = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1)
            : .secondarySystemGroupedBackground
    })
    static let red = Color.red
}

extension Palette {
    static let hairline = Color(.separator)
    static let stitch = Color(.separator)

    /// Light on the top edge fading to nothing by the bottom — reads as a bevel without a visible outline.
    static let bevel = LinearGradient(
        colors: [.white.opacity(0.14), .white.opacity(0.02), .clear],
        startPoint: .top, endPoint: .bottom
    )
    static let contactShadow = Color.black.opacity(0.06)
    static let ambientShadow = Color.black.opacity(0.08)
}
