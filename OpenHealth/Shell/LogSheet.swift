import SwiftUI

/// Hosts every logging screen in one stack. Opening straight to a destination makes it the root, so there's no menu to back out to.
struct LogSheet: View {
    @Environment(\.dismiss) private var dismiss

    let start: LogDestination

    var body: some View {
        NavigationStack {
            LogDestinationView(destination: start)
                .navigationDestination(for: LogDestination.self) { LogDestinationView(destination: $0) }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close", systemImage: "xmark") { dismiss() }
                    }
                }
        }
        .presentationDetents(start == .menu ? [.medium, .large] : [.large])
    }
}
