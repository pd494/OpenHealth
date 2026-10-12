import SwiftUI

struct RootTabView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(HealthManager.self) private var health
    @Environment(GoogleHealthManager.self) private var google
    @State private var selection = DebugLaunch.tab ?? .today

    var body: some View {
        TabView(selection: $selection) {
            ForEach(AppTab.allCases) { tab in
                NavigationStack {
                    destination(for: tab)
                        .toolbar(.hidden, for: .navigationBar)
                }
                .tabItem { Label(tab.title, systemImage: tab.symbol) }
                .tag(tab)
            }
        }
        .toolbarBackground(Palette.background, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .preferredColorScheme(.dark)
        .tint(Palette.green)
        .sensoryFeedback(.selection, trigger: selection)
        .errorAlert("OpenHealth", message: Bindable(health).errorMessage)
        .errorAlert("Google Health", message: Bindable(google).errorMessage)
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

    @ViewBuilder private func destination(for tab: AppTab) -> some View {
        switch tab {
        case .today: TodayView()
        case .sleep: SleepView()
        case .fitness: FitnessView()
        case .journal: JournalView()
        }
    }
}
