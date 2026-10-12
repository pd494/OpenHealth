import SwiftUI

struct MiniStat: View {
    let stat: MetricStat

    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(stat.label).font(.caption2).foregroundStyle(.secondary).lineLimit(1)
            Text(stat.value).metricNumber(.caption, weight: .semibold).lineLimit(1).minimumScaleFactor(0.7)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white.opacity(0.05), in: .rect(cornerRadius: 12))
        .accessibilityElement(children: .combine)
    }
}
