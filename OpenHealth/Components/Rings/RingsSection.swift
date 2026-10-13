import SwiftUI

struct RingsSection: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    @Environment(DashboardLayoutStore.self) private var store

    let isEditing: Bool

    static let ringStagger = 0.08

    private var perRow: Int { typeSize.isAccessibilitySize ? 1 : 3 }

    var body: some View {
        let rings = store.layout.rings
        if rings.isEmpty {
            Text("Tap Add to show a metric as a ring.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        } else {
            RingFlowLayout(maxPerRow: perRow, spacing: 4) {
                ForEach(Array(rings.enumerated()), id: \.element.id) { index, item in
                    RingCell(metric: item.metric, isEditing: isEditing, showsDivider: index % perRow != 0)
                        .environment(\.fillDelay, Double(index) * Self.ringStagger)
                }
            }
        }
    }
}
