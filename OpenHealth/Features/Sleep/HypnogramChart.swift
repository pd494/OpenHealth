import Charts
import SwiftUI

struct HypnogramChart: View {
    let night: SleepNight

    private static let rows = SleepStage.allCases.map(\.title)

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Stages").cardTitle()
            Chart(night.segments) { segment in
                RectangleMark(
                    xStart: .value("Start", segment.start),
                    xEnd: .value("End", segment.end),
                    y: .value("Stage", segment.stage.title),
                    height: .ratio(0.78)
                )
                .cornerRadius(3)
                .foregroundStyle(segment.stage.color)
            }
            .chartYScale(domain: Self.rows)
            .chartYAxis {
                AxisMarks { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.6, dash: [3, 4])).foregroundStyle(Palette.stitch)
                    AxisValueLabel().foregroundStyle(Color.secondary)
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .hour, count: 2)) { _ in
                    AxisValueLabel(format: .dateTime.hour(), anchor: .top).foregroundStyle(Color.secondary)
                }
            }
            .frame(height: 190)
            .accessibilityLabel("Sleep stages through the night")
        }
        .card()
    }
}
