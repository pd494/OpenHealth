import SwiftUI

enum MetricDomain: Sendable {
    case activity
    case heart
    case body
    case nutrition
    case hydration
    case sleep
    case mind

    var tint: Color {
        switch self {
        case .activity: Palette.activity
        case .heart: Palette.heart
        case .body: Palette.body
        case .nutrition: Palette.nutrition
        case .hydration: Palette.hydration
        case .sleep: Palette.sleep
        case .mind: Palette.mind
        }
    }

    var ringLabel: Color {
        switch self {
        case .activity: Palette.rgb(0x007E79)
        case .heart: Palette.rgb(0xC84235)
        case .body: Palette.rgb(0x9A5D00)
        case .nutrition: Palette.rgb(0x327C36)
        case .hydration: Palette.rgb(0x155DA6)
        case .sleep: Palette.rgb(0x6E528A)
        case .mind: Palette.rgb(0x8F478F)
        }
    }

    /// Dark, saturated colour at the active end of a ring's arc.
    var ringStart: Color {
        switch self {
        case .activity: Palette.rgb(0x26D2D2)
        case .heart: Palette.rgb(0xFF594B)
        case .body: Palette.rgb(0xFFA82B)
        case .nutrition: Palette.rgb(0x5CCB57)
        case .hydration: Palette.rgb(0x399AFF)
        case .sleep: Palette.rgb(0x6F6397)
        case .mind: Palette.rgb(0xC66ED6)
        }
    }

    /// Lighter colour at the start of a ring's arc.
    var ringEnd: Color {
        switch self {
        case .activity: Palette.rgb(0x5EEAD4)
        case .heart: Palette.rgb(0xFF9A3C)
        case .body: Palette.rgb(0xFFD66B)
        case .nutrition: Palette.rgb(0xB7E86A)
        case .hydration: Palette.rgb(0x7FD4FF)
        case .sleep: Palette.rgb(0xB6ADD5)
        case .mind: Palette.rgb(0xF5A3D6)
        }
    }
}
