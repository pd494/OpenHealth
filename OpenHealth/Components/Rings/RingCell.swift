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
                if showsDivider { Hairline(axis: .vertical).padding(.vertical, 18).offset(x: -2) }
            }
            .overlay(alignment: .topLeading) {
                if isEditing { HideBadge(metric: metric).scaleEffect(0.8).offset(x: -4, y: -4) }
            }
            // Dragging is touch-only; VoiceOver users reorder from the actions rotor instead.
            .accessibilityAction(named: "Move earlier") { shift(-1) }
            .accessibilityAction(named: "Move later") { shift(1) }
            .accessibilityAction(named: "Move to metrics") { withMotion(reduceMotion: reduceMotion) { store.layout.hide(metric) } }
    }

    private func shift(_ offset: Int) {
        withMotion(reduceMotion: reduceMotion) { store.layout.shift(metric, by: offset) }
    }
}
