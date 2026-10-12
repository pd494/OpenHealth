import SwiftUI

struct RingsSection: View {
    @Environment(HealthManager.self) private var health
    @Environment(DashboardLayoutStore.self) private var store
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let isEditing: Bool

    static let ringStagger = 0.08

    private var layout: DashboardLayout { store.layout }
    private var showsDetails: Bool { !layout.ringDetailsCollapsed }

    var body: some View {
        if !layout.rings.isEmpty || isEditing {
            VStack(alignment: .leading, spacing: 14) {
                SectionHeader(title: "Goals") {
                    if layout.ringsMode != .standard || !layout.rings.isEmpty { chevron }
                }
                content
            }
            .card()
        }
    }

    private var chevron: some View {
        Button(showsDetails ? "Hide details" : "Show details", systemImage: "chevron.down") {
            withMotion(reduceMotion: reduceMotion) { store.toggleRingDetails() }
        }
        .labelStyle(.iconOnly)
        .font(.body.weight(.bold))
        .foregroundStyle(Palette.red)
        .rotationEffect(.degrees(showsDetails ? 0 : -90))
        .frame(width: Layout.minTapTarget, height: Layout.minTapTarget, alignment: .trailing)
        .contentShape(.rect)
        .sensoryFeedback(.selection, trigger: layout.ringDetailsCollapsed)
    }

    @ViewBuilder private var content: some View {
        if layout.rings.isEmpty {
            Text("Switch a goal tile to a ring to see it here.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        } else if layout.ringsMode == .standard || !showsDetails {
            RingsRows(rings: layout.rings, isEditing: isEditing, showsDetails: showsDetails && layout.ringsMode == .standard)
        } else {
            let isExpanded = layout.ringsMode == .expanded
            VStack(spacing: 16) {
                ForEach(Array(layout.rings.enumerated()), id: \.element.id) { index, item in
                    if index > 0 { Hairline() }
                    RingStatsRow(
                        metric: item.metric,
                        isEditing: isEditing,
                        ringSize: isExpanded ? Layout.ringSize : 76
                    )
                    .environment(\.fillDelay, Double(index) * Self.ringStagger)
                }
            }
            .softLift()
        }
    }
}
