import SwiftUI

/// One optional value, so only one sheet can be active at a time.
enum TodaySheet: String, Identifiable {
    case water
    case goals
    case googleConnection

    var id: String { rawValue }
}

extension View {
    func todaySheets(_ sheet: Binding<TodaySheet?>) -> some View {
        self.sheet(item: sheet) { destination in
            switch destination {
            case .water: WaterSheet().presentationDetents([.medium, .large])
            case .goals: GoalsSheet().presentationDetents([.medium, .large])
            case .googleConnection: GoogleConnectionSheet()
            }
        }
    }
}
