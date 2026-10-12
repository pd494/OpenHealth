import SwiftUI

struct ReorderHandle<ID: Hashable>: View {
    @Environment(\.reorderActions) private var actions

    @State private var isActive = false

    let id: ID

    var body: some View {
        Grid(horizontalSpacing: 3, verticalSpacing: 3) {
            ForEach(0..<3, id: \.self) { _ in
                GridRow {
                    Circle().frame(width: 3, height: 3)
                    Circle().frame(width: 3, height: 3)
                }
            }
        }
        .foregroundStyle(.white.opacity(isActive ? 0.7 : 0.16))
        .animation(.snappy, value: isActive)
        .frame(width: Layout.minTapTarget, height: Layout.minTapTarget)
        .contentShape(.rect)
        .padding(-(Layout.minTapTarget - 20) / 2)
        .gesture(reorderGesture)
        .accessibilityHidden(true)
    }

    private var reorderGesture: some Gesture {
        LongPressGesture(minimumDuration: 0.2)
            .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .named(ReorderSpace.name)))
            .onChanged { value in
                guard case .second(true, let drag) = value else { return }
                isActive = true
                actions.lift(id)
                if let drag { actions.drag(id, drag.startLocation, drag.location) }
            }
            .onEnded { _ in
                isActive = false
                actions.drop()
            }
    }
}
