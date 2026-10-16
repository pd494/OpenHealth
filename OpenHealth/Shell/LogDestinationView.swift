import SwiftUI

/// The screen for one destination. Each case is replaced by its real screen as that screen lands.
struct LogDestinationView: View {
    let destination: LogDestination

    var body: some View {
        switch destination {
        case .menu: LogMenu()
        case .food, .activity, .water, .weight:
            ComingSoonView(title: destination.title, symbol: destination.symbol)
                .navigationTitle(destination.title)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
