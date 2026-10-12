import Observation

@MainActor @Observable
final class AppDependencies {
    let health: HealthManager
    let google: GoogleHealthManager
    let layout: DashboardLayoutStore

    init() {
        health = .shared
        google = .shared
        layout = DashboardLayoutStore()
    }
}
