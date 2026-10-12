import SwiftUI

struct RootTabView: View {
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
    }

    @ViewBuilder private func destination(for tab: AppTab) -> some View {
        switch tab {
        case .today: TodayView()
        case .sleep, .fitness, .journal: TabPlaceholder(tab: tab)
        }
    }
}
