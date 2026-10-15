import SwiftUI

struct ReorderDrag {
    let metric: MetricID
    var slot: Int
    var location: CGPoint
    /// Finger offset from the item's top-left corner, so it doesn't jump to centre under the finger.
    let grab: CGSize
    let origin: CGPoint
    let pickedUpAt = Date.now
    private(set) var isArmed = false
    /// Set on release while the held item glides to its slot, so the drag copy and the real item swap at the same spot.
    private(set) var isSettling = false

    init(metric: MetricID, slot: Int, at point: CGPoint, cellOrigin: CGPoint) {
        self.metric = metric
        self.slot = slot
        location = point
        origin = point
        grab = CGSize(width: point.x - cellOrigin.x, height: point.y - cellOrigin.y)
    }

    /// True once the item may start swapping places, so a pick-up that drifts a little doesn't reshuffle straight away.
    mutating func arm(at point: CGPoint) -> Bool {
        if !isArmed, Date.now.timeIntervalSince(pickedUpAt) > 0.15, hypot(point.x - origin.x, point.y - origin.y) > 10 {
            isArmed = true
        }
        return isArmed
    }

    mutating func settle(at cellOrigin: CGPoint) {
        isSettling = true
        location = CGPoint(x: cellOrigin.x + grab.width, y: cellOrigin.y + grab.height)
    }
}

extension View {
    /// Hold to pick up, drag to reorder, lift to drop. Points are in the named space; `end` must be safe to call twice.
    func reorderDrag(
        _ drag: Binding<ReorderDrag?>,
        in space: String,
        isEnabled: Bool,
        simultaneous: Bool = false,
        pickUp: @escaping (CGPoint) -> Void,
        move: @escaping (CGPoint) -> Void,
        end: @escaping () -> Void
    ) -> some View {
        modifier(ReorderDragModifier(
            drag: drag, space: space, isEnabled: isEnabled, simultaneous: simultaneous,
            pickUp: pickUp, move: move, end: end
        ))
    }
}

private struct ReorderDragModifier: ViewModifier {
    @Binding var drag: ReorderDrag?
    let space: String
    let isEnabled: Bool
    let simultaneous: Bool
    let pickUp: (CGPoint) -> Void
    let move: (CGPoint) -> Void
    let end: () -> Void

    @GestureState private var isActive = false

    func body(content: Content) -> some View {
        Group {
            if simultaneous {
                content.simultaneousGesture(gesture, isEnabled: isEnabled)
            } else {
                content.gesture(gesture, isEnabled: isEnabled)
            }
        }
        // A gesture cancelled mid-drag (Edit toggled, app backgrounded) never reaches `onEnded`, but its state still resets.
        .onChange(of: isActive) { _, active in
            if !active { finish() }
        }
        .sensoryFeedback(trigger: drag?.metric, pickUpFeedback)
        .sensoryFeedback(trigger: drag?.slot, slotFeedback)
    }

    private var gesture: some Gesture {
        LongPressGesture(minimumDuration: 0.4, maximumDistance: 6)
            .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .named(space)))
            .updating($isActive) { _, active, _ in active = true }
            .onChanged { value in
                guard case .second(true, let dragValue?) = value else { return }
                if drag == nil { pickUp(dragValue.startLocation) }
                move(dragValue.location)
            }
            .onEnded { _ in finish() }
    }

    private func pickUpFeedback(from old: MetricID?, to new: MetricID?) -> SensoryFeedback? {
        old == nil && new != nil ? .impact(weight: .medium) : nil
    }

    private func slotFeedback(from old: Int?, to new: Int?) -> SensoryFeedback? {
        old != nil && new != nil ? .selection : nil
    }

    private func finish() {
        guard drag != nil else { return }
        end()
    }
}
