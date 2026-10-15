import SwiftUI

/// Every metric that isn't a ring, six pills to a page. Collapsing closes from the bottom, so the card slides up over the pills.
struct PillsSection: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(DashboardLayoutStore.self) private var store

    var isExpanded = true

    /// The pills' natural height. An explicit number animates smoothly where `nil` to `0` would jump.
    @State private var contentHeight = 0.0
    @State private var page: Int? = 0

    private static let pageSize = 6
    private static let spacing = 8.0

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
    }

    private func pager(_ pages: [[DashboardItem]]) -> some View {
        VStack(spacing: 8) {
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top, spacing: 0) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, items in
                        LazyVGrid(columns: columns, spacing: Self.spacing) {
                            ForEach(Array(items.enumerated()), id: \.element.id) { position, item in
                                MetricPill(metric: item.metric.descriptor)
                                    .overlay(alignment: .leading) {
                                        if position % columnCount == 1 { Hairline(axis: .vertical).padding(.vertical, 6).offset(x: -4) }
                                    }
                                    .overlay(alignment: .bottom) {
                                        if position / columnCount < (items.count - 1) / columnCount {
                                            Hairline(axis: .horizontal).padding(.horizontal, 12).offset(y: 4)
                                        }
                                    }
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
            if pages.count > 1 {
                PageDots(count: pages.count, current: min(currentPage, pages.count - 1), page: $page)
            }
        }
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
    ScrollView { PillsSection().padding() }
        .background(Palette.background)
        .environment(DashboardLayoutStore(layout: .default))
}
