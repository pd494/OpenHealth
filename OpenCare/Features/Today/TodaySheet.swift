import SwiftUI

/// One optional value, so only one sheet can be active at a time.
enum TodaySheet: String, Identifiable {
    case water
    case goals
    case googleConnection
    case insights

    var id: String { rawValue }
}

extension View {
    func todaySheets(_ sheet: Binding<TodaySheet?>) -> some View {
        self.sheet(item: sheet) { destination in
            switch destination {
            case .water: WaterSheet().presentationDetents([.medium])
            case .goals: GoalsSheet().presentationDetents([.medium])
            case .googleConnection: GoogleConnectionSheet()
            case .insights: InsightsSheet()
            }
        }
    }
}
