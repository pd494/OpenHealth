import SwiftUI

struct MetricSummaryCard: View {
    @Environment(\.dynamicTypeSize) private var typeSize

    let metric: MetricID
    let series: MetricSeries
    @Binding var range: MetricRange

    var body: some View {
        VStack(spacing: 16) {
            let layout = typeSize.isAccessibilitySize
                ? AnyLayout(VStackLayout(alignment: .leading, spacing: 12))
                : AnyLayout(HStackLayout(alignment: .bottom, spacing: 16))
            layout {
                VStack(alignment: .leading, spacing: 4) {
                    Text(metric.descriptor.valueText)
                        .font(.system(.largeTitle, weight: .bold))
                    Text(series.latest.date, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                VStack(alignment: typeSize.isAccessibilitySize ? .leading : .trailing, spacing: 4) {
                    Text("Normal range")
                        .font(.subheadline.bold())
                        .foregroundStyle(MetricDomain.vitals.adaptiveLabel)
                    Text("\(metric.descriptor.format.number(series.normalBand.lowerBound)) – \(metric.descriptor.format.number(series.normalBand.upperBound))\(metric.descriptor.unitSuffix)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .accessibilityElement(children: .combine)
            }
            Picker("Date range", selection: $range) {
                ForEach(MetricRange.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)
            .frame(minHeight: Layout.minTapTarget)
            MetricTrendChart(metric: metric, range: range, series: series)
        }
        .padding(Layout.cardPadding)
        .surface()
    }
}

#Preview {
    MetricSummaryCard(metric: .restingHeartRate,
                      series: MetricSeries(metric: .restingHeartRate, range: .month), range: .constant(.month))
        .padding()
        .pageBackground()
}
