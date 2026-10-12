import Inject
import SwiftUI

struct TodayView: View {
    @ObserveInjection private var inject
    @Environment(HealthManager.self) private var health
    @Environment(GoogleHealthManager.self) private var google
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @AppStorage("dashboardMetricsExpanded") private var metricsExpanded = true
    @State private var showsMetricPicker = false
    @State private var sheet: TodaySheet?
    @State private var isEditing = DebugLaunch.flag("editMode")
    @State private var viewportHeight = 0.0
    @State private var gridTop = 0.0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                TodayHeader(sheet: $sheet, isEditing: $isEditing)
                    .todayEntrance(0)
                if google.isConnected {
                    GoogleStatusCard(sheet: $sheet).todayEntrance(1)
                } else if !health.isConnected && !health.isDemo {
                    ConnectionCard(sheet: $sheet).todayEntrance(1)
                }
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "Daily overview") {
                        Button("Add", systemImage: "plus") {
                            showsMetricPicker = true
                        }
                        .font(.subheadline.weight(.semibold))
                        .frame(minHeight: Layout.minTapTarget)
                        .padding(.vertical, -10)
                        Button {
                            withMotion(reduceMotion: reduceMotion) { metricsExpanded.toggle() }
                        } label: {
                            Image(systemName: "chevron.down")
                                .rotationEffect(.degrees(metricsExpanded ? 0 : -90))
                                .foregroundStyle(.secondary)
                                .frame(width: Layout.minTapTarget, height: Layout.minTapTarget)
                                .contentShape(.rect)
                        }
                        .padding(.vertical, -10)
                        .accessibilityLabel(metricsExpanded ? "Collapse metrics" : "Expand metrics") // [VERIFY] confirm label matches intent
                    }
                    RingsSection(isEditing: isEditing, onSelect: select)
                        .padding(Layout.overviewInset)
                        .overlay {
                            RoundedRectangle(cornerRadius: Layout.cardRadius, style: .continuous)
                                .strokeBorder(Palette.hairline, lineWidth: 1)
                        }
                    if metricsExpanded {
                        TileGrid(isEditing: isEditing, fillHeight: fillHeight, onSelect: select)
                            .onGeometryChange(for: Double.self) { $0.frame(in: .named(Self.content)).minY } action: { gridTop = $0 }
                        if isEditing { EditTray() }
                    }
                }
                .todayEntrance(2)
                VStack(alignment: .leading, spacing: 16) {
                    if health.isDemo { DemoBanner(sheet: $sheet) }
                    TodayFooter()
                }
                .todayEntrance(3)
            }
            .padding(.horizontal, Layout.screenPadding)
            .padding(.bottom, Layout.screenPadding)
            .coordinateSpace(name: Self.content)
        }
        .onGeometryChange(for: Double.self) { $0.size.height } action: { viewportHeight = $0 }
        .pageBackground()
        .enableInjection()
        .tint(.blue)
        .todaySheets($sheet)
        .sheet(isPresented: $showsMetricPicker) {
            SheetContainer(title: "Add metrics") {
                ScrollView { EditTray().padding(Layout.screenPadding) }
            }
            .presentationDetents([.medium, .large])
        }
        .onOpenURL { url in
            if DeepLink(url: url) == .water { sheet = .water }
        }
    }

    private static let content = "todayContent"

    /// Space from the top of the grid to the bottom of the visible screen.
    private var fillHeight: Double? {
        guard viewportHeight > 0, gridTop > 0 else { return nil }
        return viewportHeight - gridTop - Layout.screenPadding
    }

    private func select(_ metric: MetricID) {
        switch metric {
        case .hydration: sheet = .water
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
