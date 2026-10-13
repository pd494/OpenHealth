import SwiftUI

@main
struct OpenHealthApp: App {
    @State private var layout = DashboardLayoutStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(layout)
        }
    }
}
