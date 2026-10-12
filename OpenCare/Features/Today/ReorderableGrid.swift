import SwiftUI

/// A grid whose cells are reordered individually by dragging a `ReorderHandle` inside them.
/// The lifted cell is drawn as an overlay so it tracks the finger while the others spring aside.
struct ReorderableGrid<Item: Identifiable & Hashable, Cell: View>: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var width = 0.0
    @State private var lifted: Item.ID?
    @State private var grab: CGSize?
    @State private var finger = CGPoint.zero

    let items: [Item]
    let columns: Int
    let rowHeight: Double
    let onMove: (Item.ID, Int) -> Void
    @ViewBuilder let cell: (Item) -> Cell

    private var slotWidth: Double { (width - Layout.tileSpacing * Double(columns - 1)) / Double(columns) }
    private var liftedIndex: Int? { items.firstIndex { $0.id == lifted } }

    var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: Layout.tileSpacing), count: columns),
            spacing: Layout.tileSpacing
        ) {
            ForEach(items) { item in
                slot(item)
            }
        }
        .animation(reduceMotion ? nil : .snappy, value: items)
        .coordinateSpace(name: ReorderSpace.name)
        .onGeometryChange(for: Double.self) { $0.size.width } action: { width = $0 }
        .overlay(alignment: .topLeading) { liftedCell }
        .environment(\.reorderActions, ReorderActions(lift: lift, drag: drag, drop: drop))
        .reorderHaptics(lifted: lifted, slot: liftedIndex)
    }

    private func slot(_ item: Item) -> some View {
        let index = items.firstIndex(of: item) ?? 0
        return cell(item)
            .frame(height: rowHeight)
            .opacity(item.id == lifted ? 0 : 1)
            .overlay {
                if item.id == lifted {
                    RoundedRectangle(cornerRadius: Layout.cardRadius)
                        .strokeBorder(Palette.stitch, style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
                }
            }
            .accessibilityAction(named: "Move earlier") { onMove(item.id, index - 1) }
            .accessibilityAction(named: "Move later") { onMove(item.id, index + 1) }
    }

    @ViewBuilder private var liftedCell: some View {
        if let index = liftedIndex {
            let origin = grab.map { CGPoint(x: finger.x - $0.width, y: finger.y - $0.height) } ?? origin(of: index)
            cell(items[index])
                .frame(width: slotWidth, height: rowHeight)
                .scaleEffect(1.04)
                .shadow(color: .black.opacity(0.45), radius: 18, y: 10)
                .offset(x: origin.x, y: origin.y)
                .allowsHitTesting(false)
        }
    }

    private func origin(of index: Int) -> CGPoint {
        CGPoint(
            x: Double(index % columns) * (slotWidth + Layout.tileSpacing),
            y: Double(index / columns) * (rowHeight + Layout.tileSpacing)
        )
    }

    private func slot(at point: CGPoint) -> Int {
        let column = min(max(Int(point.x / (slotWidth + Layout.tileSpacing)), 0), columns - 1)
        let row = min(max(Int(point.y / (rowHeight + Layout.tileSpacing)), 0), (items.count - 1) / columns)
        return min(row * columns + column, items.count - 1)
    }

    private func lift(_ key: AnyHashable) {
        guard lifted == nil, let id = key.base as? Item.ID else { return }
        lifted = id
    }

    private func drag(_ key: AnyHashable, start: CGPoint, location: CGPoint) {
        guard let id = key.base as? Item.ID, id == lifted, let index = liftedIndex else { return }
        if grab == nil {
            let origin = origin(of: index)
            grab = CGSize(width: start.x - origin.x, height: start.y - origin.y)
        }
        finger = location
        let target = slot(at: location)
        if target != index { onMove(id, target) }
    }

    private func drop() {
        withAnimation(reduceMotion ? nil : .smooth) {
            lifted = nil
            grab = nil
        }
    }
}
