import Observation

@MainActor @Observable
final class AppDependencies {
    let health: HealthManager
    let google: GoogleHealthManager
    let layout: DashboardLayoutStore
    let journal: JournalStore

    init() {
        health = .shared
        google = .shared
        layout = DashboardLayoutStore()
        journal = JournalStore()
    }
}
