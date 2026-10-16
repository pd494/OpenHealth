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
    /// The faint lavender behind the sleep chart's lanes, the steps between its blocks, and its lane names.
    static let sleepGuide = MetricDomain.sleep.ringStart.opacity(0.13)
    static let sleepConnector = MetricDomain.sleep.ringStart.opacity(0.2)
    static let sleepGuideLabel = MetricDomain.sleep.ringStart.opacity(0.55)
    /// The wash behind the sleep card's tiles and tab tray.
    static let sleepWash = MetricDomain.sleep.ringStart.opacity(0.09)
}

extension MetricDomain {
    /// Readable on a card: the deep label shade in light mode, the bright ring colour in dark.
    var adaptiveLabel: Color {
        Color(uiColor: UIColor { traits in UIColor(traits.userInterfaceStyle == .dark ? ringStart : ringLabel) })
    }
}

extension Palette {
    static let separator = Color(.separator)

    /// Light on the top edge fading to nothing by the bottom — reads as a bevel without a visible outline.
    static let bevel = LinearGradient(
        colors: [.white.opacity(0.14), .white.opacity(0.02), .clear],
        startPoint: .top, endPoint: .bottom
    )
    static let contactShadow = Color.black.opacity(0.06)
    static let ambientShadow = Color.black.opacity(0.08)
}
