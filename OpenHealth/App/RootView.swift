import Inject
import SwiftUI

struct RootView: View {
    @ObserveInjection private var inject
    @Environment(\.scenePhase) private var scenePhase
    @Environment(HealthManager.self) private var health
    @Environment(GoogleHealthManager.self) private var google

    var body: some View {
        NavigationStack {
            TodayView()
                .reloadsOnInjection()
                .toolbar(.hidden, for: .navigationBar)
        }
        .tint(.blue)
        .errorAlert("OpenHealth", message: Bindable(health).errorMessage)
        .errorAlert("Google Health", message: Bindable(google).errorMessage)
        .enableInjection()
        .task { await loadInitialData() }
        .task(id: isPollingSteps) { await pollGoogleSteps() }
    }

    private static let stepPollInterval = Duration.seconds(30)

    private var isPollingSteps: Bool { google.isConnected && scenePhase == .active }

    private func loadInitialData() async {
        #if targetEnvironment(simulator)
        if !health.isConnected && !google.isConnected { health.loadDemo() }
        #endif
        await AppRefresh.run(force: true)
        if google.isConnected && health.googleStepWakeupsEnabled {
            await health.checkGoogleSharedSteps()
        }
    }

    private func pollGoogleSteps() async {
        guard isPollingSteps else { return }
        while !Task.isCancelled {
            do { try await Task.sleep(for: Self.stepPollInterval) } catch { return }
            await google.syncStepsOnly()
        }
    }

}
