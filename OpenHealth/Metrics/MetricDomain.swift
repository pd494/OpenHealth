import SwiftUI

enum MetricDomain {
    case activity
    case nutrition
    case hydration
    case sleep
    case body
    case cardio
    case vitals

    var ringLabel: Color {
        switch self {
        case .activity: rgb(0x007E79)
        case .nutrition: rgb(0x155DA6)
        case .hydration: rgb(0x155DA6)
        case .sleep: rgb(0x5E45B5)
        case .body: rgb(0x4B5563)
        case .cardio: rgb(0x1E4FC2)
        case .vitals: rgb(0x1F7A3A)
        }
    }

    /// Dark, saturated colour at the active end of a ring's arc.
    var ringStart: Color {
        switch self {
        case .activity: rgb(0x26D2D2)
        case .nutrition: rgb(0x399AFF)
        case .hydration: rgb(0x399AFF)
        case .sleep: rgb(0x7B61D6)
        case .body: rgb(0x8B95A5)
        case .cardio: rgb(0x3B6FF0)
        case .vitals: rgb(0x3DBE6A)
        }
    }

    /// Lighter colour at the start of a ring's arc.
    var ringEnd: Color {
        switch self {
        case .activity: rgb(0x5EEAD4)
        case .nutrition: rgb(0x7FD4FF)
        case .hydration: rgb(0x7FD4FF)
        case .sleep: rgb(0xC9B8EE)
        case .body: rgb(0xC7CDD8)
        case .cardio: rgb(0x93B4FF)
        case .vitals: rgb(0xA8E8BA)
        }
    }

    var ringDeep: Color {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        UIColor(ringStart).getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return Color(hue: h, saturation: min(s * 1.1, 1), brightness: b * 0.7, opacity: a)
    }

    private func rgb(_ hex: UInt32) -> Color {
        Color(red: Double((hex >> 16) & 0xFF) / 255, green: Double((hex >> 8) & 0xFF) / 255, blue: Double(hex & 0xFF) / 255)
    }
}
