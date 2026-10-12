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
}
