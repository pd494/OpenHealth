import SwiftUI

/// The app's four tabs, each with its own navigation stack, and the one sheet every Log button opens.
struct MainTabs: View {
    @State private var selection = DebugLaunch.string("tab").flatMap(AppTab.init(debugName:)) ?? .today
    @State private var logging = DebugLaunch.string("sheet").flatMap(LogDestination.init(debugName:))

    var body: some View {
        TabView(selection: $selection) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                NavigationStack { content(for: tab) }
                    .tabItem { Label(tab.title, systemImage: tab.symbol) }
                    .tag(tab)
            }
        }
        .environment(\.presentLog) { logging = $0 }
        .sheet(item: $logging) { LogSheet(start: $0) }
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
