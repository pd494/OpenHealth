import SwiftUI

enum Palette {
    static let background = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? .black
            : .systemGroupedBackground
    })
    static let card = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1)
            : .secondarySystemGroupedBackground
    })
    static let widgetBackground = Color(red: 0.10, green: 0.11, blue: 0.12)
    static let track = Color(.tertiarySystemFill)
    static let red = Color.red
    static let green = Color.teal
    static let purple = Color.purple

    static func progress(_ ratio: Double) -> Color {
        if ratio >= 1 { return purple }
        if ratio >= 0.5 { return green }
        return red
    }
}
