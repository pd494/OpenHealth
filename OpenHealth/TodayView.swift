import Inject
import SwiftUI

struct TodayView: View {
    @ObserveInjection private var inject
    @State private var showsMetricPicker = false
    @State private var isEditing = DebugLaunch.flag("editMode")

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                TodayHeader(isEditing: $isEditing)
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
                    RingsSection(isEditing: isEditing)
                        .padding(Layout.overviewInset)
                        .surface()
                }
                .todayEntrance(1)
            }
            .padding(.horizontal, Layout.screenPadding)
            .padding(.bottom, Layout.screenPadding)
        }
        .pageBackground()
        .enableInjection()
        .tint(.blue)
        .sheet(isPresented: $showsMetricPicker) {
            SheetContainer(title: "Add metrics") {
                ScrollView { EditTray().padding(Layout.screenPadding) }
            }
            .presentationDetents([.medium, .large])
        }
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
