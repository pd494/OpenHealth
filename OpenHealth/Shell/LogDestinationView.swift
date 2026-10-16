import SwiftUI

/// The screen for one destination. Each case is replaced by its real screen as that screen lands.
struct LogDestinationView: View {
    let destination: LogDestination

    var body: some View {
        switch destination {
        case .menu: LogMenu()
        case .activity: LogActivityView()
        case .water: LogValueView(value: .water)
        case .weight: LogValueView(value: .weight)
        case .food:
            ComingSoonView(title: destination.title, symbol: destination.symbol)
                .navigationTitle(destination.title)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview { NavigationStack { LogDestinationView(destination: .activity) } }
