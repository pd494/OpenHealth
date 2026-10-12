import SwiftUI

enum Palette {
    static let background = Color(red: 0.055, green: 0.064, blue: 0.072)
    static let card = Color(red: 0.115, green: 0.125, blue: 0.132)
    static let widgetBackground = Color(red: 0.10, green: 0.11, blue: 0.12)
    static let track = Color.white.opacity(0.13)
    static let red = Color(red: 1.0, green: 0.32, blue: 0.38)
    static let green = Color(red: 0.55, green: 0.84, blue: 0.34)
    static let purple = Color(red: 0.72, green: 0.50, blue: 1.0)

    static func progress(_ ratio: Double) -> Color {
        if ratio >= 1 { return purple }
        if ratio >= 0.5 { return green }
        return red
    }
}
