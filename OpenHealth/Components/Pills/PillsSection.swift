import SwiftUI

struct PillsSection: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(DashboardLayoutStore.self) private var store

    var isExpanded = true
    var ringPoint: CGPoint?
    @Binding var ringSlot: Int

    /// The pills' natural height. An explicit number animates smoothly where `nil` to `0` would jump.
    @State private var contentHeight = 0.0
    @State private var page: Int? = 0
    @State private var viewportFrame = CGRect.zero
    @State private var rowHeight = 0.0
    @State private var drag: ReorderDrag?
    /// Which side edge the held pill rests at (-1, 0 or 1); the task below turns pages while it's non-zero.
    @State private var edge = 0
    @AccessibilityFocusState private var focusedPill: MetricID?

    private static let space = "pills"
    private static let pageSize = 6
    private static let spacing = 8.0
    private static let edgeZone = 28.0
    private static let armDistance = 8.0

    private var columnCount: Int { typeSize.isAccessibilitySize ? 1 : 2 }

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: Self.spacing), count: columnCount)
    }

    private var pages: [[DashboardItem]] {
        let hidden = store.layout.hidden
        return stride(from: 0, to: hidden.count, by: Self.pageSize).map {
            Array(hidden[$0..<min($0 + Self.pageSize, hidden.count)])
        }
    }

    private var currentPage: Int { page ?? 0 }

    private var cellWidth: Double {
        (viewportFrame.width - Self.spacing * Double(columnCount - 1)) / Double(columnCount)
    }

    var body: some View {
        let pages = pages
        pager(pages)
            .padding(.top, 12)
            .fixedSize(horizontal: false, vertical: true)
            .onGeometryChange(for: Double.self) { $0.size.height } action: { contentHeight = $0 }
            .frame(height: isExpanded ? contentHeight : 0, alignment: .top)
            .clipped()
            .opacity(isExpanded ? 1 : 0)
            .accessibilityHidden(!isExpanded)
            .onChange(of: pages.count) { _, count in
                if currentPage >= count { page = max(count - 1, 0) }
            }
            .onChange(of: ringPoint) { _, point in
                guard let point else { return }
                ringSlot = slot(at: CGPoint(x: point.x - viewportFrame.minX, y: point.y - viewportFrame.minY)) ?? store.layout.hidden.count
            }
            .task(id: edge) {
                if edge != 0 { try? await flipPages(toward: edge) }
            }
    }

    private func pager(_ pages: [[DashboardItem]]) -> some View {
        VStack(spacing: 8) {
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top, spacing: 0) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, items in
                        LazyVGrid(columns: columns, spacing: Self.spacing) {
                            ForEach(Array(items.enumerated()), id: \.element.id) { position, item in
                                MetricPill(metric: item.metric.descriptor)
                                    .opacity(drag?.metric == item.metric ? 0 : 1)
                                    .overlay(alignment: .leading) {
                                        if position % columnCount == 1 { Hairline(axis: .vertical).padding(.vertical, 6).offset(x: -4) }
                                    }
                                    .overlay(alignment: .bottom) {
                                        if position / columnCount < (items.count - 1) / columnCount {
                                            Hairline(axis: .horizontal).padding(.horizontal, 12).offset(y: 4)
                                        }
                                    }
                                    .onGeometryChange(for: Double.self) { $0.size.height } action: { rowHeight = $0 }
                                    .accessibilityAction(named: "Move earlier") { shift(item.metric, by: -1) }
                                    .accessibilityAction(named: "Move later") { shift(item.metric, by: 1) }
                                    .accessibilityFocused($focusedPill, equals: item.metric)
                            }
                        }
                        .containerRelativeFrame(.horizontal)
                        .id(index)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $page)
            .scrollDisabled(drag != nil)
            .coordinateSpace(.named(Self.space))
            .onGeometryChange(for: CGRect.self) { $0.frame(in: .named(RingsSection.cardSpace)) } action: { viewportFrame = $0 }
            .overlay(alignment: .topLeading) { floatingPill }
            // On the viewport rather than each pill, so the gesture survives its pill moving to another page.
            .reorderDrag($drag, in: Self.space, isEnabled: !typeSize.isAccessibilitySize, simultaneous: true, pickUp: pickUp(at:), move: move(to:), end: drop)
            if pages.count > 1 {
                PageDots(count: pages.count, current: min(currentPage, pages.count - 1), page: $page)
            }
        }
    }

    @ViewBuilder private var floatingPill: some View {
        if let drag {
            MetricPill(metric: drag.metric.descriptor)
                .environment(\.fillsOnAppear, false)
                .frame(width: cellWidth, height: rowHeight)
                .background(Palette.card, in: .rect(cornerRadius: Layout.pillRadius))
                .shadow(color: .black.opacity(0.14), radius: 12, y: 6)
                .scaleEffect(reduceMotion || drag.isSettling ? 1 : 1.04)
                .offset(x: drag.location.x - drag.grab.width, y: drag.location.y - drag.grab.height)
                // Only a settling drop animates the position; otherwise the swap's spring would make the pill trail the finger.
                .animation(drag.isSettling ? Motion.resolve(Motion.state, reduceMotion: reduceMotion) : nil, value: drag.location)
                .allowsHitTesting(false)
        }
    }

    private func slot(at point: CGPoint) -> Int? {
        let column = min(max(Int(point.x / (cellWidth + Self.spacing)), 0), columnCount - 1)
        let row = min(max(Int(point.y / (rowHeight + Self.spacing)), 0), Self.pageSize / columnCount - 1)
        let slot = currentPage * Self.pageSize + row * columnCount + column
        return slot < store.layout.hidden.count ? slot : nil
    }

    private func origin(ofSlot slot: Int) -> CGPoint {
        let local = slot - currentPage * Self.pageSize
        return CGPoint(
            x: Double(local % columnCount) * (cellWidth + Self.spacing),
            y: Double(local / columnCount) * (rowHeight + Self.spacing)
        )
    }

    private func pickUp(at point: CGPoint) {
        guard rowHeight > 0, let slot = slot(at: point) else { return }
        withAnimation(Motion.press) {
            drag = ReorderDrag(metric: store.layout.hidden[slot].metric, slot: slot, at: point, cellOrigin: origin(ofSlot: slot))
        }
    }

    private func move(to point: CGPoint) {
        guard let current = drag, !current.isSettling else { return }
        drag?.location = point
        if drag?.arm(at: point) == true { reorder(under: point) }
        let hasTravelled = hypot(point.x - current.origin.x, point.y - current.origin.y) > Self.armDistance
        edge = !hasTravelled ? 0 : point.x < Self.edgeZone ? -1 : point.x > viewportFrame.width - Self.edgeZone ? 1 : 0
    }

    private func flipPages(toward direction: Int) async throws {
        while true {
            try await Task.sleep(for: .milliseconds(550))
            // `drop()` zeroes `edge` but keeps `drag` alive while settling, and the sleep can resume before the task's cancellation lands.
            guard edge == direction else { return }
            let target = currentPage + direction
            guard pages.indices.contains(target) else { return }
            withMotion(reduceMotion: reduceMotion) { page = target }
            try await Task.sleep(for: .milliseconds(350))
            guard let location = drag?.location else { return }
            reorder(under: location)
        }
    }

    private func reorder(under point: CGPoint) {
        guard let drag, drag.isArmed, !drag.isSettling else { return }
        let target = slot(at: point) ?? store.layout.hidden.count - 1
        guard target != drag.slot else { return }
        withMotion(reduceMotion: reduceMotion) {
            store.layout.move(drag.metric, to: target)
            self.drag?.slot = target
        }
    }

    private func drop() {
        edge = 0
        guard let current = drag, !current.isSettling else { return }
        // A release during the pause after a page flip hasn't been reordered yet.
        reorder(under: current.location)
        guard let held = drag else { return }
        withAnimation(Motion.resolve(Motion.state, reduceMotion: reduceMotion)) {
            drag?.settle(at: origin(ofSlot: held.slot))
        } completion: {
            drag = nil
        }
    }

    private func shift(_ metric: MetricID, by offset: Int) {
        withMotion(reduceMotion: reduceMotion) { store.layout.shift(metric, by: offset) }
        let hidden = store.layout.hidden
        guard let slot = hidden.firstIndex(where: { $0.metric == metric }) else { return }
        if slot / Self.pageSize != currentPage {
            withMotion(reduceMotion: reduceMotion) { page = slot / Self.pageSize }
        }
        focusedPill = metric
        AccessibilityNotification.Announcement("Position \(slot + 1) of \(hidden.count)").post()
    }
}

private struct PageDots: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let count: Int
    let current: Int
    @Binding var page: Int?

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<count, id: \.self) { index in
                Circle()
                    .fill(index == current ? Color.primary : Color.secondary.opacity(0.3))
                    .frame(width: 6, height: 6)
            }
        }
        .animation(Motion.resolve(Motion.state, reduceMotion: reduceMotion), value: current)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Pages")
        .accessibilityValue("\(current + 1) of \(count)")
        .accessibilityAdjustableAction { direction in
            let target = switch direction {
            case .increment: min(current + 1, count - 1)
            case .decrement: max(current - 1, 0)
            @unknown default: current
            }
            withMotion(reduceMotion: reduceMotion) { page = target }
        }
    }
}

#Preview {
    ScrollView { PillsSection(ringSlot: .constant(0)).padding() }
        .background(Palette.background)
        .environment(DashboardLayoutStore(layout: .default))
}
