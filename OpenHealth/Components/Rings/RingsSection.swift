import SwiftUI

struct RingsSection: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(DashboardLayoutStore.self) private var store

    let isEditing: Bool
    /// Expanded when a ring is held over the metrics, so there's somewhere to see it land.
    @Binding var showsMetrics: Bool
    @Binding var pointOverMetrics: CGPoint?
    let ringSlot: Int

    /// Spans the rings and the metrics below, so a drag can leave this section.
    static let cardSpace = "card"

    @State private var frames: [MetricID: CGRect] = [:]
    @State private var gridFrame = CGRect.zero
    @State private var drag: ReorderDrag?
    @State private var isOverMetrics = false

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
                        .opacity(drag?.metric == item.metric ? 0 : 1)
                        .onGeometryChange(for: CGRect.self) { $0.frame(in: .named(Self.cardSpace)) } action: { frames[item.metric] = $0 }
                }
            }
            .onGeometryChange(for: CGRect.self) { $0.frame(in: .named(Self.cardSpace)) } action: { gridFrame = $0 }
            .overlay(alignment: .topLeading) { floatingRing }
            .sensoryFeedback(trigger: isOverMetrics) { _, entered in entered ? .impact(weight: .light) : nil }
            .reorderDrag($drag, in: Self.cardSpace, isEnabled: !isEditing, pickUp: pickUp(at:), move: move(to:), end: drop)
        }
    }

    @ViewBuilder private var floatingRing: some View {
        if let drag, let frame = frames[drag.metric] {
            MetricRingView(metric: drag.metric.descriptor)
                .environment(\.fillsOnAppear, false)
                .padding(4)
                .frame(width: frame.width, height: frame.height)
                .scaleEffect(reduceMotion || drag.isSettling ? 1 : isOverMetrics ? 0.7 : 1.06)
                .opacity(isOverMetrics ? 0.65 : 1)
                .animation(Motion.resolve(Motion.state, reduceMotion: reduceMotion), value: isOverMetrics)
                .shadow(color: .black.opacity(0.14), radius: 12, y: 6)
                .offset(x: drag.location.x - drag.grab.width - gridFrame.minX, y: drag.location.y - drag.grab.height - gridFrame.minY)
                // Only a settling drop animates the position; otherwise the swap's spring would make the ring trail the finger.
                .animation(drag.isSettling ? Motion.resolve(Motion.state, reduceMotion: reduceMotion) : nil, value: drag.location)
                .allowsHitTesting(false)
        }
    }

    private func nearestRing(to point: CGPoint) -> MetricID? {
        frames
            .filter { id, _ in store.layout.rings.contains { $0.metric == id } }
            .min { hypot($0.value.midX - point.x, $0.value.midY - point.y) < hypot($1.value.midX - point.x, $1.value.midY - point.y) }?
            .key
    }

    private func pickUp(at point: CGPoint) {
        let rings = store.layout.rings.map(\.metric)
        guard let metric = nearestRing(to: point), let frame = frames[metric], let slot = rings.firstIndex(of: metric) else { return }
        withAnimation(Motion.press) {
            drag = ReorderDrag(metric: metric, slot: slot, at: point, cellOrigin: frame.origin)
        }
    }

    private func move(to point: CGPoint) {
        guard let current = drag, !current.isSettling else { return }
        drag?.location = point
        let overMetrics = point.y > gridFrame.maxY
        isOverMetrics = overMetrics
        pointOverMetrics = overMetrics ? point : nil
        if overMetrics {
            showsMetrics = true
            return
        }
        guard drag?.arm(at: point) == true else { return }
        let rings = store.layout.rings.map(\.metric)
        guard let over = nearestRing(to: point), over != current.metric, let target = rings.firstIndex(of: over) else { return }
        withMotion(reduceMotion: reduceMotion) {
            store.layout.move(current.metric, to: target)
            drag?.slot = target
        }
    }

    private func drop() {
        guard let held = drag, !held.isSettling else { return }
        if isOverMetrics {
            isOverMetrics = false
            pointOverMetrics = nil
            withMotion(reduceMotion: reduceMotion) { store.layout.hide(held.metric, at: ringSlot) }
            drag = nil
            return
        }
        guard let frame = frames[held.metric] else {
            drag = nil
            return
        }
        withAnimation(Motion.resolve(Motion.state, reduceMotion: reduceMotion)) {
            drag?.settle(at: frame.origin)
        } completion: {
            drag = nil
        }
    }
}
