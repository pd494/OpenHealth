import Inject
import SwiftUI

struct TodayView: View {
    @ObserveInjection private var inject
    @Environment(DashboardLayoutStore.self) private var store
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showsMetricPicker = false
    @State private var showsSettings = DebugLaunch.string("settings") != nil
    @State private var isEditing = DebugLaunch.flag("editMode")
    @AppStorage("showsMetrics") private var showsMetrics = false
    @State private var ringPoint: CGPoint?
    @State private var ringSlot = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                TodayHeader(isEditing: $isEditing, openSettings: { showsSettings = true })
                    .todayEntrance(0)
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader(title: "Daily overview") {
                        Button("Add", systemImage: "plus") {
                            showsMetricPicker = true
                        }
                        .font(.subheadline.weight(.semibold))
                        .frame(minHeight: Layout.minTapTarget)
                        .padding(.vertical, -10)
                    }
                    VStack(spacing: 0) {
                        RingsSection(isEditing: isEditing, showsMetrics: $showsMetrics, pointOverMetrics: $ringPoint, ringSlot: ringSlot)
                        if !store.layout.hidden.isEmpty {
                            PillsSection(isExpanded: showsMetrics, ringPoint: ringPoint, ringSlot: $ringSlot)
                        }
                    }
                    .coordinateSpace(.named(RingsSection.cardSpace))
                    .padding(Layout.overviewInset)
                    .surface()
                    // Bound to the value rather than wrapped around the tap, so the open/close plays in full however it's triggered.
                    .animation(Motion.resolve(.smooth(duration: 0.4), reduceMotion: reduceMotion), value: showsMetrics)
                    .overlay(alignment: .topTrailing) {
                        if !store.layout.hidden.isEmpty { metricsToggle }
                    }
                }
                .todayEntrance(1)
                SleepCard(night: .demo)
                    .todayEntrance(2)
            }
            .padding(.horizontal, Layout.screenPadding)
            .padding(.bottom, Layout.screenPadding)
        }
        .pageBackground()
        .enableInjection()
        .tint(.blue)
        .sheet(isPresented: $showsSettings) { SettingsSheet() }
        .sheet(isPresented: $showsMetricPicker) {
            SheetContainer(title: "Add metrics") {
                ScrollView { EditTray().padding(Layout.screenPadding) }
            }
            .presentationDetents([.medium, .large])
        }
    }

    private var metricsToggle: some View {
        Button {
            showsMetrics.toggle()
        } label: {
            Image(systemName: "chevron.down")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .rotationEffect(.degrees(showsMetrics ? 180 : 0))
                .animation(reduceMotion ? nil : .spring(duration: 0.45, bounce: 0.3), value: showsMetrics)
                .frame(width: Layout.minTapTarget, height: Layout.minTapTarget)
                .contentShape(.rect)
        }
        .buttonStyle(PressableButtonStyle(scale: 0.85))
        .offset(x: 6, y: -8)
        .accessibilityLabel("Metrics")
        .accessibilityValue(showsMetrics ? "Expanded" : "Collapsed")
    }
}

private struct SectionHeader<Trailing: View>: View {
    let title: String
    @ViewBuilder var trailing: Trailing

    var body: some View {
        HStack {
            Text(title)
                .font(.system(.headline))
                .accessibilityAddTraits(.isHeader)
            Spacer()
            trailing
        }
    }
}

#Preview {
    TodayView()
        .environment(DashboardLayoutStore(layout: .default))
}
