import SwiftUI

struct RingsRows: View {
    @Environment(HealthManager.self) private var health

    let rings: [DashboardItem]
    let isEditing: Bool
    let showsDetails: Bool

    private static let perRow = 3

    private var rows: [[DashboardItem]] {
        stride(from: 0, to: rings.count, by: Self.perRow).map { Array(rings[$0..<min($0 + Self.perRow, rings.count)]) }
    }

    var body: some View {
        VStack(spacing: 18) {
            ForEach(rows, id: \.first?.id) { row in
                Grid(horizontalSpacing: 10, verticalSpacing: 12) {
                    GridRow {
                        ForEach(0..<Self.perRow, id: \.self) { index in
                            if index < row.count {
                                RingCell(metric: row[index].metric, isEditing: isEditing)
                            } else {
                                Color.clear.frame(maxWidth: .infinity, maxHeight: 0)
                            }
                        }
                    }
                    if showsDetails {
                        GridRow(alignment: .top) {
                            ForEach(0..<Self.perRow, id: \.self) { index in
                                if index < row.count {
                                    VStack(spacing: 6) {
                                        ForEach(health.stats(for: row[index].metric)) { MiniStat(stat: $0) }
                                    }
                                } else {
                                    Color.clear.frame(maxWidth: .infinity, maxHeight: 0)
                                }
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
            }
        }
    }
}
