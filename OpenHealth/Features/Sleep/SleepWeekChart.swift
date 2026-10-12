import Charts
import SwiftUI

struct SleepWeekChart: View {
    let week: [DayValue]
    let goal: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Last 7 nights").cardTitle()
            Chart {
                ForEach(week) { night in
                    BarMark(x: .value("Day", night.date, unit: .day), y: .value("Hours", night.value))
                        .foregroundStyle(night.id == week.last?.id ? Palette.sleep : Palette.sleep.opacity(0.4))
                        .cornerRadius(5)
                }
                RuleMark(y: .value("Goal", goal))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))
                    .foregroundStyle(Palette.stitch)
            }
            .chartYScale(domain: 0...10)
            .chartYAxis {
                AxisMarks(values: [0, 4, 8]) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5)).foregroundStyle(Palette.hairline)
                    AxisValueLabel().foregroundStyle(Color.secondary)
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisValueLabel(format: .dateTime.weekday(.narrow)).foregroundStyle(Color.secondary)
                }
            }
            .frame(height: 150)
            .accessibilityLabel("Hours slept over the last seven nights")
        }
        .card()
    }
}
