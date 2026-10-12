import SwiftUI

struct TileGrid: View {
    @Environment(HealthManager.self) private var health
    @Environment(DashboardLayoutStore.self) private var store
    @Environment(\.dynamicTypeSize) private var typeSize
    @ScaledMetric(relativeTo: .title) private var gridHeight = Layout.gridTileHeight
    @ScaledMetric(relativeTo: .body) private var listHeight = Layout.listTileHeight
    @ScaledMetric(relativeTo: .body) private var pillHeight = Layout.pillTileHeight

    let isEditing: Bool
    /// Height left on screen below the rings; pills resize to fill it exactly.
    var fillHeight: Double?
    let onSelect: (MetricID) -> Void

    private var tileLayout: TileLayout { typeSize.isAccessibilitySize ? .list : store.layout.tileLayout }

    private var fit: PillFit? {
        guard tileLayout == .pills, let fillHeight, !items.isEmpty else { return nil }
        // The grid frame adds 16pt of shadow room below the last row.
        return PillFit(count: items.count, height: fillHeight - 16, spacing: Layout.tileSpacing)
    }

    private var columns: Int { fit?.columns ?? tileLayout.columns }

    private var rowHeight: Double {
        if let fit { return fit.rowHeight }
        return switch tileLayout {
        case .pills: pillHeight
        case .grid: gridHeight
        case .list: listHeight
        }
    }

    @State private var page = 0

    private var items: [DashboardItem] { store.layout.metrics }
    /// Pills are short enough to show every metric at once; taller tiles page in sixes.
    private var pageSize: Int { tileLayout == .pills ? max(items.count, 1) : 6 }
    private var pageCount: Int { max(1, (items.count + pageSize - 1) / pageSize) }

    var body: some View {
        VStack(spacing: 8) {
            TabView(selection: $page) {
                ForEach(0..<pageCount, id: \.self) { index in
                    let start = index * pageSize
                    let pageItems = Array(items.dropFirst(start).prefix(pageSize))
                    ReorderableGrid(
                        items: pageItems,
                        columns: columns,
                        rowHeight: rowHeight,
                        onMove: { id, target in store.moveTile(id, to: start + target) }
                    ) { item in
                        Button { onSelect(item.metric) } label: {
                            if tileLayout == .pills {
                                MetricPill(value: health.value(item.metric), showsHandle: isEditing)
                            } else {
                                MetricTile(value: health.value(item.metric), layout: tileLayout, showsHandle: isEditing, history: health.trends[item.metric] ?? [])
                            }
                        }
                        .buttonStyle(.pressable)
                        .overlay(alignment: .topLeading) {
                            if isEditing { HideBadge(metric: item.metric) }
                        }
                        .overlay(alignment: .bottomTrailing) {
                            if isEditing { StyleBadge(metric: item.metric, style: .ring) }
                        }
                        .contextMenu { TileContextMenu(metric: item.metric, style: item.style) }
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, isEditing ? 12 : 0)
                    .padding(.horizontal, Layout.screenPadding)
                    .padding(.bottom, 16)
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: Double((min(items.count, pageSize) + columns - 1) / columns) * (rowHeight + Layout.tileSpacing) - Layout.tileSpacing + (isEditing ? 12 : 0) + 16)
            .padding(.horizontal, -Layout.screenPadding)
            if pageCount > 1 {
                HStack(spacing: 8) {
                    ForEach(0..<pageCount, id: \.self) { index in
                        Button { page = index } label: {
                            Circle().fill(index == page ? Color.primary : Color.secondary.opacity(0.3))
                                .frame(width: 6, height: 6)
                                .frame(width: Layout.minTapTarget, height: Layout.minTapTarget)
                                .contentShape(.rect)
                        }
                        .accessibilityLabel("Page \(index + 1)") // [VERIFY] confirm label matches intent
                        .accessibilityAddTraits(index == page ? .isSelected : [])
                    }
                }
            }
        }
        .onChange(of: pageCount) { _, count in page = min(page, count - 1) }
    }
}

/// Row height that stretches the two-column pill grid to fill the space available, within readable bounds.
struct PillFit {
    static let minRow = 50.0
    static let maxRow = 54.0

    let columns = 2
    let rowHeight: Double

    init(count: Int, height: Double, spacing: Double) {
        let rows = Double((count + 1) / 2)
        rowHeight = min(max((height - spacing * (rows - 1)) / rows, Self.minRow), Self.maxRow)
    }
}
