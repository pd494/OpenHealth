import SwiftUI

struct HideBadge: View {
    @Environment(DashboardLayoutStore.self) private var store
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let metric: MetricID

    var body: some View {
        Button("Hide \(metric.descriptor.title)", systemImage: "minus.circle.fill") {
            withMotion(reduceMotion: reduceMotion) { store.layout.setVisible(metric, false) }
        }
        .labelStyle(.iconOnly)
        .font(.title2)
        .symbolRenderingMode(.palette)
        .foregroundStyle(.white, Palette.red)
        .frame(width: Layout.minTapTarget, height: Layout.minTapTarget)
        .offset(x: -14, y: -14)
        .sensoryFeedback(.impact(weight: .light), trigger: store.layout.hidden.count)
    }
}
