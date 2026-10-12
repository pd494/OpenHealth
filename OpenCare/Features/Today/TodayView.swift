import SwiftUI

struct TodayView: View {
    @Environment(HealthManager.self) private var health
    @Environment(GoogleHealthManager.self) private var google
    @State private var sheet: TodaySheet?
    @State private var route: TodayRoute? = DebugLaunch.string("route") == "stress" ? .stress : nil
    @State private var isEditing = DebugLaunch.flag("editMode")

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
    }

    private func select(_ metric: MetricID) {
        switch metric {
        case .hydration: sheet = .water
        case .stress: route = .stress
        default: break
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
