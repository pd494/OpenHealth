import Charts
import SwiftUI

struct ActivitySummaryCard: View {
    private static let lineColor = Color(red: 1, green: 0.48, blue: 0.36)

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text("Activity summary")
                    .font(.subheadline.weight(.semibold))
                Spacer(minLength: 8)
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .accessibilityHidden(true)
            }
            .foregroundStyle(.secondary)
            Text(Duration.seconds(ActivityHistory.totalMinutes * 60).formatted(.units(allowed: [.hours, .minutes], width: .narrow, zeroValueUnits: .show(length: 1))))
                .font(.title.weight(.heavy))
            Chart(ActivityHistory.levels.indices, id: \.self) { index in
                AreaMark(
                    x: .value("Day", index),
                    y: .value("Minutes", ActivityHistory.cumulativeMinutes[index])
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(LinearGradient(
                    colors: [Self.lineColor.opacity(0.2), .clear],
                    startPoint: .top, endPoint: .bottom
                ))
                LineMark(
                    x: .value("Day", index),
                    y: .value("Minutes", ActivityHistory.cumulativeMinutes[index])
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(Self.lineColor)
                if index == ActivityHistory.levels.count - 1 {
                    PointMark(
                        x: .value("Day", index),
                        y: .value("Minutes", ActivityHistory.cumulativeMinutes[index])
                    )
                    .foregroundStyle(Self.lineColor)
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .frame(height: 80)
            .accessibilityLabel("Cumulative activity over the last 30 days")
        }
        .padding(Layout.cardPadding)
        .surface()
    }
}

#Preview {
    ActivitySummaryCard().padding().pageBackground()
}
