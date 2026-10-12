import SwiftUI

struct MiniStat: View {
    let stat: MetricStat

    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(stat.label).font(.caption2).foregroundStyle(.secondary).lineLimit(1)
            Text(stat.value).metricNumber(.subheadline, weight: .semibold).lineLimit(1).minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}
