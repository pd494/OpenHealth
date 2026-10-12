import SwiftUI

struct TodayView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(HealthManager.self) private var health
    @Environment(GoogleHealthManager.self) private var google
    @State private var sheet: TodaySheet?
    @State private var route: TodayRoute? = DebugLaunch.string("route") == "stress" ? .stress : nil
    @State private var isEditing = DebugLaunch.flag("editMode")

    private static let stepPollInterval = Duration.seconds(30)

    private var isPollingSteps: Bool { google.isConnected && scenePhase == .active }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
                TodayHeader(sheet: $sheet, isEditing: $isEditing)
                if google.isConnected {
                    GoogleStatusCard(sheet: $sheet)
                } else if !health.isConnected && !health.isDemo {
                    ConnectionCard(sheet: $sheet)
                }
                RingsSection(isEditing: isEditing)
                TileGrid(isEditing: isEditing, onSelect: select)
                if isEditing { EditTray() }
                AskCard(sheet: $sheet)
                if health.isDemo { DemoBanner(sheet: $sheet) }
                TodayFooter()
            }
            .padding(.horizontal, Layout.screenPadding)
            .padding(.vertical, Layout.screenPadding)
        }
        .background(Palette.background)
        .preferredColorScheme(.dark)
        .tint(Palette.green)
        .todaySheets($sheet)
        .navigationDestination(item: $route) { _ in StressView() }
        .onOpenURL { url in
            if DeepLink(url: url) == .water { sheet = .water }
        }
        .errorAlert("OpenCare", message: Bindable(health).errorMessage)
        .errorAlert("Google Health", message: Bindable(google).errorMessage)
        .task { await loadInitialData() }
        .task(id: isPollingSteps) { await pollGoogleSteps() }
    }

    private func select(_ metric: MetricID) {
        switch metric {
        case .hydration: sheet = .water
        case .stress: route = .stress
        default: break
        }
    }

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

#Preview("Demo") {
    TodayView()
        .environment(HealthManager.preview)
        .environment(DashboardLayoutStore(layout: .default))
        .environment(GoogleHealthManager.shared)
}

#Preview("Not connected") {
    TodayView()
        .environment(HealthManager())
        .environment(DashboardLayoutStore(layout: .default))
        .environment(GoogleHealthManager.shared)
}
