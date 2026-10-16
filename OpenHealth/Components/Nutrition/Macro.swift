import SwiftUI

enum Macro: CaseIterable {
    case protein
    case carbs
    case fat

    var metric: MetricDescriptor {
        switch self {
        case .protein: MetricID.protein.descriptor
        case .carbs: MetricID.carbs.descriptor
        case .fat: MetricID.fat.descriptor
        }
    }

    var tint: Color {
        switch self {
        case .protein: Color(red: 1, green: 0.48, blue: 0.54)
        case .carbs: Color(red: 0.43, green: 0.66, blue: 1)
        case .fat: Color(red: 1, green: 0.72, blue: 0.29)
        }
    }
}
