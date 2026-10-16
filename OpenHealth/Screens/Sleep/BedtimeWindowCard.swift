import Charts
import SwiftUI

struct BedtimeWindowCard: View {
    @ScaledMetric(relativeTo: .body) private var chartHeight = 110.0

    /// Hours after 10 PM, so a bedtime past midnight stays to the right of one before it.
    private static let origin = 22.0
    private static let targetBedtime = 23.0 - origin
    private static let targetWake = 31.5 - origin
    private static let tickLabels = [0.0: "10p", 4: "2a", 8: "6a"]
    /// Oldest first, as (bedtime on the 22...32 scale, wake hour after midnight).
    private static let nights = [(23.3, 7.0), (23.7, 7.4), (24.4, 6.9), (23.5, 7.3), (23.8, 7.6), (24.9, 7.8), (23.7, 7.3)]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text("Bedtime window").font(.subheadline.weight(.semibold))
                Spacer(minLength: 8)
                Text("Last 7 nights").font(.caption).foregroundStyle(.secondary)
            }
            chart
            Text("Within 40 minutes on 5 of 7 nights.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(Layout.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .surface()
    }

    private var chart: some View {
        Chart {
            RectangleMark(xStart: .value("Target bedtime", Self.targetBedtime), xEnd: .value("Target wake", Self.targetWake))
                .foregroundStyle(MetricDomain.sleep.ringStart.opacity(0.1))
            ForEach([Self.targetBedtime, Self.targetWake], id: \.self) { target in
                RuleMark(x: .value("Target", target))
                    .foregroundStyle(MetricDomain.sleep.ringStart.opacity(0.5))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 3]))
            }
            ForEach(Self.nights.indices, id: \.self) { index in
                let night = Self.nights[index]
                let nightsAgo = Self.nights.count - 1 - index
                BarMark(
                    xStart: .value("Bedtime", night.0 - Self.origin),
                    xEnd: .value("Wake", night.1 + 24 - Self.origin),
                    y: .value("Night", nightsAgo),
                    height: .fixed(8)
                )
                .clipShape(.capsule)
                .foregroundStyle(nightsAgo == 0 ? MetricDomain.sleep.ringStart : MetricDomain.sleep.ringEnd)
            }
        }
        .chartXScale(domain: 0...10)
        .chartYScale(domain: -0.5...(Double(Self.nights.count) - 0.5))
        .chartXAxis {
            AxisMarks(values: Array(Self.tickLabels.keys)) { value in
                AxisGridLine()
                AxisValueLabel {
                    if let hours = value.as(Double.self) { Text(Self.tickLabels[hours, default: ""]) }
                }
            }
        }
        .chartYAxis {
            AxisMarks(values: Array(Self.nights.indices)) { value in
                AxisValueLabel {
                    if let nightsAgo = value.as(Int.self) { Text(weekday(nightsAgo: nightsAgo)) }
                }
            }
        }
        .frame(height: chartHeight)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Bedtime window, last 7 nights")
        .accessibilityValue("Target 11 PM to 7:30 AM. Within 40 minutes on 5 of 7 nights.")
    }

    private func weekday(nightsAgo: Int) -> String {
        let day = Calendar.current.date(byAdding: .day, value: -nightsAgo, to: .now)!
        return day.formatted(.dateTime.weekday(.narrow))
    }
}

#Preview {
    BedtimeWindowCard()
        .padding()
        .background(Palette.background)
}
