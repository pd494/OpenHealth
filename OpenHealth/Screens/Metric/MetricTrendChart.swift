import Charts
import SwiftUI

struct MetricTrendChart: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let metric: MetricID
    let range: MetricRange
    let series: MetricSeries

    var body: some View {
        Chart {
            RectangleMark(
                xStart: .value("Start", series.points[0].date),
                xEnd: .value("End", series.latest.date),
                yStart: .value("Normal minimum", series.normalBand.lowerBound),
                yEnd: .value("Normal maximum", series.normalBand.upperBound)
            )
            .foregroundStyle(metric.descriptor.domain.ringEnd.opacity(0.25))
            .accessibilityHidden(true)
            ForEach(series.points, id: \.date) { point in
                LineMark(x: .value("Date", point.date), y: .value(metric.descriptor.title, point.value))
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 2.5))
                    .foregroundStyle(metric.descriptor.domain.ringStart)
                    .accessibilityLabel(Text(point.date, format: .dateTime.month(.abbreviated).day()))
                    .accessibilityValue(metric.descriptor.format.number(point.value) + metric.descriptor.unitSuffix)
            }
            PointMark(x: .value("Date", series.latest.date), y: .value("Latest", series.latest.value))
                .foregroundStyle(metric.descriptor.domain.ringStart)
                .accessibilityHidden(true)
        }
        .chartYScale(domain: series.yDomain)
        .chartXAxis { AxisMarks(values: .automatic(desiredCount: 3)) }
        .chartYAxis { AxisMarks(position: .leading, values: .automatic(desiredCount: 3)) }
        .frame(height: 180)
        .id(reduceMotion ? range : .month)
        .transition(.opacity)
        .animation(Motion.resolve(Motion.state, reduceMotion: reduceMotion), value: range)
        .accessibilityLabel("\(metric.descriptor.title) trend")
    }
}

#Preview {
    MetricTrendChart(metric: .restingHeartRate, range: .month,
                     series: MetricSeries(metric: .restingHeartRate, range: .month))
        .padding()
}
