import SwiftUI

@main
struct OpenHealthApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @State private var dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(dependencies.health)
                .environment(dependencies.google)
                .environment(dependencies.layout)
                .environment(dependencies.journal)
                .modelContainer(dependencies.journal.container)
        }
        .onChange(of: scenePhase) {
            guard scenePhase == .active else { return }
            dependencies.health.checkDayRollover()
            Task { await AppRefresh.run(force: true) }
        }
    }
}
