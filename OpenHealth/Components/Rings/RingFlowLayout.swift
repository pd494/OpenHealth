import SwiftUI

/// Equal-width cells, up to `maxPerRow` per row, with an incomplete last row centered.
struct RingFlowLayout: SwiftUI.Layout {
    var maxPerRow = 3
    var spacing = 14.0

    private func cellWidth(_ width: Double) -> Double {
        (width - spacing * Double(maxPerRow - 1)) / Double(maxPerRow)
    }

    private func rows(_ count: Int) -> [Range<Int>] {
        stride(from: 0, to: count, by: maxPerRow).map { $0..<min($0 + maxPerRow, count) }
    }

    private func rowHeights(_ subviews: SwiftUI.LayoutSubviews, width: Double) -> [Double] {
        rows(subviews.count).map { row in
            row.map { subviews[$0].sizeThatFits(.init(width: cellWidth(width), height: nil)).height }.max() ?? 0
        }
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: SwiftUI.LayoutSubviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 320
        let heights = rowHeights(subviews, width: width)
        return CGSize(width: width, height: heights.reduce(0, +) + spacing * Double(max(heights.count - 1, 0)))
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: SwiftUI.LayoutSubviews, cache: inout ()) {
        let cell = cellWidth(bounds.width)
        let heights = rowHeights(subviews, width: bounds.width)
        var y = bounds.minY
        for (row, height) in zip(rows(subviews.count), heights) {
            let rowWidth = cell * Double(row.count) + spacing * Double(row.count - 1)
            var x = bounds.minX + (bounds.width - rowWidth) / 2
            for index in row {
                subviews[index].place(at: CGPoint(x: x, y: y), anchor: .topLeading, proposal: .init(width: cell, height: height))
                x += cell + spacing
            }
            y += height + spacing
        }
    }
}
