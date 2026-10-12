import SwiftUI

@main
struct OpenCareApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @State private var health = HealthManager.shared
    @State private var google = GoogleHealthManager.shared

    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(health)
                .environment(google)
        }
        .onChange(of: scenePhase) {
            guard scenePhase == .active else { return }
            health.checkDayRollover()
            Task { await AppRefresh.run(force: true) }
        }
    }
}
