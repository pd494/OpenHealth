import Charts
import SwiftUI

struct StressTrendCard: View {
    let day: StressDay

    private var verdict: String? {
        guard let average = day.average, let range = day.normalRange else { return nil }
        if range.contains(average) { return "Within your normal range" }
        return average > range.upperBound ? "Above your normal range" : "Below your normal range"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Trends").cardTitle()
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Stress score").font(.subheadline).foregroundStyle(.secondary)
                    Text(day.average.map { $0.formatted(.number.precision(.fractionLength(0))) } ?? "—")
                        .metricNumber(.largeTitle, weight: .bold)
                    Text(verdict ?? "Needs a few more days").font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                sparkline
            }
        }
        .card()
    }

    private var sparkline: some View {
        Chart(day.week) { entry in
            LineMark(x: .value("Day", entry.date, unit: .day), y: .value("Score", entry.value))
                .interpolationMethod(.catmullRom)
                .foregroundStyle(Palette.mind)
            PointMark(x: .value("Day", entry.date, unit: .day), y: .value("Score", entry.value))
                .foregroundStyle(Palette.mind)
                .symbolSize(entry.id == day.week.last?.id ? 40 : 0)
        }
        .chartYScale(domain: 0...100)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .frame(width: 130, height: 56)
        .accessibilityHidden(true)
    }
}
