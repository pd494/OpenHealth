import SwiftUI

struct RingsSection: View {
    @Environment(HealthManager.self) private var health
    @Environment(DashboardLayoutStore.self) private var store

    let isEditing: Bool

    private var layout: DashboardLayout { store.layout }
    private var showsDetails: Bool { !layout.ringDetailsCollapsed }

    var body: some View {
        if !layout.rings.isEmpty || isEditing {
            VStack(alignment: .leading, spacing: 20) {
                SectionHeader(title: "Goals") {
                    if layout.ringsMode != .standard || !layout.rings.isEmpty { chevron }
                }
                content
            }
            .card(radius: 28)
        }
    }

    private var chevron: some View {
        Button(showsDetails ? "Hide details" : "Show details", systemImage: "chevron.down") {
            withAnimation(.snappy) { store.toggleRingDetails() }
        }
        .labelStyle(.iconOnly)
        .font(.body.weight(.bold))
        .foregroundStyle(Palette.red)
        .rotationEffect(.degrees(showsDetails ? 0 : -90))
        .frame(width: Layout.minTapTarget, height: Layout.minTapTarget)
        .padding(.trailing, -12)
        .sensoryFeedback(.selection, trigger: layout.ringDetailsCollapsed)
    }

    @ViewBuilder private var content: some View {
        if layout.rings.isEmpty {
            Text("Switch a goal tile to a ring to see it here.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        } else if layout.ringsMode == .standard || !showsDetails {
            RingsRows(rings: layout.rings, isEditing: isEditing, showsDetails: showsDetails && layout.ringsMode == .standard)
        } else if layout.ringsMode == .expanded {
            VStack(spacing: 14) {
                ForEach(layout.rings) { item in
                    if item.id != layout.rings.first?.id { Hairline() }
                    RingsExpandedRow(metric: item.metric, isEditing: isEditing)
                }
            }
        } else {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), alignment: .topLeading), count: 2), spacing: 18) {
                ForEach(layout.rings) { RingsBesideCell(metric: $0.metric, isEditing: isEditing) }
            }
        }
    }
}
