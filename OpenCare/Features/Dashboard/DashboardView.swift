import SwiftUI

struct DashboardView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(HealthManager.self) private var health
    @Environment(GoogleHealthManager.self) private var google
    @State private var sheet: DashboardSheet?

    private static let stepPollInterval = Duration.seconds(30)

    private var isPollingSteps: Bool { google.isConnected && scenePhase == .active }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
                DashboardHeader(sheet: $sheet)
                if google.isConnected {
                    GoogleStatusCard(sheet: $sheet)
                } else if !health.isConnected && !health.isDemo {
                    ConnectionCard(sheet: $sheet)
                }
                RingsCard()
                HydrationCard(sheet: $sheet)
                AskCard(sheet: $sheet)
                if health.isDemo { DemoBanner(sheet: $sheet) }
                DashboardFooter()
            }
            .padding(.horizontal, Layout.screenPadding)
            .padding(.vertical, Layout.screenPadding)
        }
        .background(Palette.background)
        .preferredColorScheme(.dark)
        .tint(Palette.green)
        .dashboardSheets($sheet)
        .onOpenURL { url in
            if DeepLink(url: url) == .water { sheet = .water }
        }
        .errorAlert("OpenCare", message: Bindable(health).errorMessage)
        .errorAlert("Google Health", message: Bindable(google).errorMessage)
        .task { await loadInitialData() }
        .task(id: isPollingSteps) { await pollGoogleSteps() }
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
    DashboardView()
        .environment(HealthManager.preview)
        .environment(GoogleHealthManager.shared)
}

#Preview("Not connected") {
    DashboardView()
        .environment(HealthManager())
        .environment(GoogleHealthManager.shared)
}
