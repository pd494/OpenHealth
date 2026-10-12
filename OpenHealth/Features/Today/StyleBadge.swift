import SwiftUI

struct StyleBadge: View {
    @Environment(DashboardLayoutStore.self) private var store

    let metric: MetricID
    let style: DisplayStyle

    var body: some View {
        Button(
            style == .ring ? "Show \(metric.descriptor.title) as ring" : "Show \(metric.descriptor.title) as tile",
            systemImage: style == .ring ? "circle.dashed" : "square.grid.2x2.fill"
        ) {
            withAnimation(.snappy) { store.setStyle(metric, style) }
        }
        .labelStyle(.iconOnly)
        .font(.caption.weight(.bold))
        .foregroundStyle(Color.primary)
        .frame(width: 30, height: 30)
        .background(Palette.card, in: .circle)
        .overlay { Circle().strokeBorder(Palette.stitch) }
        .frame(width: Layout.minTapTarget, height: Layout.minTapTarget)
        .contentShape(.rect)
        .sensoryFeedback(.selection, trigger: store.layout.rings.count)
    }
}
