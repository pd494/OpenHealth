import SwiftUI

struct RecentValuesCard: View {
    @Environment(\.dynamicTypeSize) private var typeSize

    let metric: MetricID
    let series: MetricSeries

    private var recent: [(date: Date, value: Double)] { Array(series.points.suffix(4).reversed()) }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(recent, id: \.date) { point in
                let layout = typeSize.isAccessibilitySize
                    ? AnyLayout(VStackLayout(alignment: .leading, spacing: 4))
                    : AnyLayout(HStackLayout(spacing: 16))
                layout {
                    Text(point.date, format: .dateTime.month(.abbreviated).day())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(metric.descriptor.format.number(point.value) + metric.descriptor.unitSuffix)
                        .bold()
                        .monospacedDigit()
                }
                .font(.body)
                .padding(.vertical, 12)
                .accessibilityElement(children: .combine)
                if point.date != recent[recent.count - 1].date { Hairline(axis: .horizontal) }
            }
        }
        .padding(.horizontal, Layout.cardPadding)
        .surface()
    }
}

#Preview {
    RecentValuesCard(metric: .restingHeartRate, series: MetricSeries(metric: .restingHeartRate, range: .week))
        .padding().pageBackground()
}
