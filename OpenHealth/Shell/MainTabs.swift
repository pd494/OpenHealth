import SwiftUI

/// The app's four tabs, each with its own navigation stack, and the one sheet every Log button opens.
struct MainTabs: View {
    @State private var selection = Self.debugTab
    @State private var paths: [AppTab: [MetricID]] = [Self.debugTab: Self.debugMetricPath]
    @State private var logging = DebugLaunch.string("sheet").flatMap(LogDestination.init(debugName:))

    private static let debugTab = DebugLaunch.string("tab").flatMap(AppTab.init(debugName:)) ?? .today
    private static let debugMetricPath = DebugLaunch.string("metric").flatMap(MetricID.init(rawValue:)).map { [$0] } ?? []

    var body: some View {
        TabView(selection: $selection) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                NavigationStack(path: path(for: tab)) {
                    content(for: tab)
                        .navigationDestination(for: MetricID.self) { MetricDetailView(metric: $0) }
                }
                    .tabItem { Label(tab.title, systemImage: tab.symbol) }
                    .tag(tab)
            }
        }
        .environment(\.presentLog) { logging = $0 }
        .sheet(item: $logging) { LogSheet(start: $0) }
    }

    private func path(for tab: AppTab) -> Binding<[MetricID]> {
        Binding(get: { paths[tab, default: []] }, set: { paths[tab] = $0 })
    }

    @ViewBuilder private func content(for tab: AppTab) -> some View {
        switch tab {
        case .today:
            TodayView().toolbar(.hidden, for: .navigationBar)
        case .nutrition:
            NutritionView()
        case .sleep:
            SleepView()
        case .fitness:
            ComingSoonView(title: tab.title, symbol: tab.symbol)
        }
    }
}

#Preview {
    MainTabs()
}
