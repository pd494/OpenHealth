@MainActor
enum AppRefresh {
    static func run(force: Bool = false) async {
        let google = GoogleHealthManager.shared
        let health = HealthManager.shared
        if google.isConnected { await google.sync(force: force) }
        if health.isConnected { await health.refresh() }
    }
}
