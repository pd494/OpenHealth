import SwiftUI

enum MetricDomain {
    case activity
    case heart
    case nutrition
    case hydration
    case sleep

    var ringLabel: Color {
        switch self {
        case .activity: rgb(0x007E79)
        case .heart: rgb(0xC84235)
        case .nutrition: rgb(0x327C36)
        case .hydration: rgb(0x155DA6)
        case .sleep: rgb(0x6C31E3)
        }
    }

    /// Dark, saturated colour at the active end of a ring's arc.
    var ringStart: Color {
        switch self {
        case .activity: rgb(0x26D2D2)
        case .heart: rgb(0xFF594B)
        case .nutrition: rgb(0x5CCB57)
        case .hydration: rgb(0x399AFF)
        case .sleep: rgb(0x6C31E3)
        }
    }

    /// Lighter colour at the start of a ring's arc.
    var ringEnd: Color {
        switch self {
        case .activity: rgb(0x5EEAD4)
        case .heart: rgb(0xFF9A3C)
        case .nutrition: rgb(0xB7E86A)
        case .hydration: rgb(0x7FD4FF)
        case .sleep: rgb(0xC6A8E6)
        }
    }

    private func rgb(_ hex: UInt32) -> Color {
        Color(red: Double((hex >> 16) & 0xFF) / 255, green: Double((hex >> 8) & 0xFF) / 255, blue: Double(hex & 0xFF) / 255)
    }
}
