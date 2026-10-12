import SwiftUI

struct RingsSection: View {
    @Environment(DashboardLayoutStore.self) private var store

    let isEditing: Bool
    var onSelect: (MetricID) -> Void = { _ in }

    static let ringStagger = 0.08

    private var layout: DashboardLayout { store.layout }
    private var showsDetails: Bool { !layout.ringDetailsCollapsed }

    var body: some View {
        if !layout.rings.isEmpty || isEditing {
            content
        }
    }

    @ViewBuilder private var content: some View {
        if layout.rings.isEmpty {
            Text("Touch and hold a metric below to show it as a ring.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        } else if layout.ringsMode == .standard || !showsDetails {
            RingsRows(rings: layout.rings, isEditing: isEditing, showsDetails: showsDetails && layout.ringsMode == .standard, onSelect: onSelect)
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
