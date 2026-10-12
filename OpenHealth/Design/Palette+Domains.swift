import SwiftUI

/// One hue per category, each well apart on the wheel so categories never read as each other.
extension Palette {
    static let activity = green
    static let heart = Color.pink
    static let sleep = Color.indigo
    static let hydration = Color.blue
    static let nutrition = Color.green
    static let body = Color.orange
    static let mind = Color.purple
}

extension Palette {
    static let stressLow = Color(red: 0.42, green: 0.84, blue: 0.52)
    static let stressMedium = Color(red: 1.0, green: 0.80, blue: 0.30)
    static let stressHigh = Color(red: 1.0, green: 0.36, blue: 0.34)
}

extension Palette {
    static let sleepDeep = Color(red: 0.36, green: 0.34, blue: 0.86)
    static let sleepREM = Color(red: 0.38, green: 0.82, blue: 0.92)
    static let sleepAwake = Color(red: 1.0, green: 0.62, blue: 0.40)
}
