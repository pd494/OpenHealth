import SwiftUI

/// Stands in for a screen that a later change fills in.
struct ComingSoonView: View {
    let title: String
    let symbol: String

    var body: some View {
        ContentUnavailableView(title, systemImage: symbol, description: Text("This screen is on its way."))
            .pageBackground()
    }
}
