import Charts
import SwiftUI

struct StressChart: View {
    let day: StressDay

    private static let gridlines: [Double] = [0, 25, 50, 75, 100]

    private var domain: ClosedRange<Date> {
        guard let first = day.points.first?.date, let last = day.points.last?.date else { return .now...Date.now }
        return first...last
    }

    var body: some View {
        Chart {
            if let sleep = day.sleepWindow {
                RectangleMark(
                    xStart: .value("Sleep start", max(sleep.lowerBound, domain.lowerBound)),
                    xEnd: .value("Sleep end", min(sleep.upperBound, domain.upperBound)),
                    yStart: .value("Min", 0),
                    yEnd: .value("Max", 100)
                )
                .foregroundStyle(Palette.sleep.opacity(0.12))
                .annotation(position: .top, alignment: .leading, spacing: -22) {
                    Image(systemName: "moon.fill")
                        .font(.caption2)
                        .foregroundStyle(Palette.sleep)
                        .padding(.leading, 6)
                        .accessibilityLabel("Sleep period")
                }
            }
            ForEach(day.points) { point in
                LineMark(x: .value("Time", point.date), y: .value("Stress", point.score))
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                    .foregroundStyle(
                        .linearGradient(
                            colors: [Palette.stressHigh, Palette.stressMedium, Palette.stressLow],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
            }
        }
        .chartYScale(domain: 0...100)
        .chartXScale(domain: domain)
        .chartYAxis {
            AxisMarks(position: .leading, values: Self.gridlines) { _ in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.6, dash: [3, 4])).foregroundStyle(Palette.stitch)
                AxisValueLabel().foregroundStyle(Color.secondary)
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .hour, count: 6)) { _ in
                AxisValueLabel(format: .dateTime.hour(), anchor: .top).foregroundStyle(Color.secondary)
            }
        }
        .frame(height: 220)
        .accessibilityLabel("Stress over the last 24 hours")
        .accessibilityValue(day.average.map { "Average \($0.formatted(.number.precision(.fractionLength(0))))" } ?? "No data")
    }
}
