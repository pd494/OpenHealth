import SwiftUI

struct LogDestinationView: View {
    let destination: LogDestination

    var body: some View {
        switch destination {
        case .menu: LogMenu()
        case .food: LogFoodView()
        case .activity: LogActivityView()
        case .water: LogValueView(value: .water)
        case .weight: LogValueView(value: .weight)
        }
    }
}

#Preview { NavigationStack { LogDestinationView(destination: .food) } }
