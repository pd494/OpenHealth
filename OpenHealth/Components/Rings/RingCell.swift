import SwiftUI

struct RingCell: View {
    @Environment(DashboardLayoutStore.self) private var store
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let metric: MetricID
    let isEditing: Bool
    var showsDivider = false

    var body: some View {
        MetricRingView(metric: metric.descriptor)
            .padding(4)
            .contentShape(.rect)
            .overlay(alignment: .leading) {
                if showsDivider { VerticalHairline().padding(.vertical, 18).offset(x: -2) }
            }
            .overlay(alignment: .topLeading) {
                if isEditing { HideBadge(metric: metric).scaleEffect(0.8).offset(x: -4, y: -4) }
            }
            .contextMenu {
                Button("Move earlier", systemImage: "arrow.left") { shift(-1) }
                Button("Move later", systemImage: "arrow.right") { shift(1) }
                Button("Hide", systemImage: "eye.slash") {
                    withMotion(reduceMotion: reduceMotion) { store.layout.setVisible(metric, false) }
                }
            }
    }

    private func shift(_ offset: Int) {
        withMotion(reduceMotion: reduceMotion) { store.layout.shift(metric, by: offset) }
    }
}

private struct VerticalHairline: View {
    var body: some View {
        Rectangle()
            .fill(Palette.separator)
            .frame(width: 1)
            .accessibilityHidden(true)
    }
}
