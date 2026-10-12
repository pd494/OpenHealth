import Charts
import SwiftUI

struct FitnessTrendCard: View {
    @Environment(HealthManager.self) private var health
    @State private var selection = MetricID.steps

    var body: some View {
        let value = health.value(selection)
        let series = health.trends[selection] ?? []
        VStack(alignment: .leading, spacing: 14) {
            Picker("Trend", selection: $selection) {
                ForEach(DemoFitness.trendMetrics, id: \.self) { Text(Self.shortTitle($0)).tag($0) }
            }
            .pickerStyle(.segmented)
            Chart {
                ForEach(series) { day in
                    BarMark(x: .value("Day", day.date, unit: .day), y: .value("Value", day.value))
                        .foregroundStyle(day.id == series.last?.id ? selection.descriptor.tint : selection.descriptor.tint.opacity(0.4))
                        .cornerRadius(5)
                }
                if let goal = value.goal {
                    RuleMark(y: .value("Goal", goal))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))
                        .foregroundStyle(Palette.stitch)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5)).foregroundStyle(Palette.hairline)
                    AxisValueLabel().foregroundStyle(Color.secondary)
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisValueLabel(format: .dateTime.weekday(.narrow)).foregroundStyle(Color.secondary)
                }
            }
            .frame(height: 170)
            .animation(.snappy, value: selection)
            .accessibilityLabel("\(selection.descriptor.title) over the last seven days")
        }
        .card()
        .sensoryFeedback(.selection, trigger: selection)
    }

    private static func shortTitle(_ id: MetricID) -> String {
        switch id {
        case .activeEnergy: "Active"
        case .exerciseMinutes: "Exercise"
        default: id.descriptor.title
        }
    }
}
