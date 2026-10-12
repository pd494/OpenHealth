import SwiftUI

enum StressBand: CaseIterable, Identifiable {
    case high
    case medium
    case low

    var id: Self { self }

    var title: String {
        switch self {
        case .high: "High"
        case .medium: "Medium"
        case .low: "Low"
        }
    }

    var color: Color {
        switch self {
        case .high: Palette.stressHigh
        case .medium: Palette.stressMedium
        case .low: Palette.stressLow
        }
    }
}
