import SwiftUI

struct TabPlaceholder: View {
    let tab: AppTab

    var body: some View {
        ContentUnavailableView(tab.title, systemImage: tab.symbol, description: Text("Coming in the next update."))
            .background(Palette.background)
    }
}
