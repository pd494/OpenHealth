import SwiftUI

struct ActivityGridCard: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor

    private static let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    private static let cellRadius = 5.0

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(ActivityHistory.start, format: .dateTime.month(.abbreviated).day()) – \(ActivityHistory.end, format: .dateTime.month(.abbreviated).day())")
                .font(.caption)
                .foregroundStyle(.secondary)
            LazyVGrid(columns: Self.columns, spacing: 4) {
                ForEach(0..<7) { index in
                    let weekday = (ActivityHistory.calendar.firstWeekday - 1 + index) % 7
                    Text(ActivityHistory.calendar.veryShortStandaloneWeekdaySymbols[weekday])
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            LazyVGrid(columns: Self.columns, spacing: 4) {
                ForEach(0..<ActivityHistory.leadingDays, id: \.self) { _ in
                    Color.clear.aspectRatio(1, contentMode: .fit)
                }
                ForEach(ActivityHistory.levels.indices, id: \.self) { index in
                    let level = ActivityHistory.levels[index]
                    RoundedRectangle(cornerRadius: Self.cellRadius, style: .continuous)
                        .fill(color(for: level))
                        .aspectRatio(1, contentMode: .fit)
                        .overlay {
                            if differentiateWithoutColor && level > 0 {
                                Text(level, format: .number)
                                    .font(.caption2)
                                    .foregroundStyle(.primary)
                            }
                        }
                }
            }
            .accessibilityHidden(true)
            ViewThatFits(in: .horizontal) {
                HStack(spacing: 12) { legend }
                VStack(alignment: .leading, spacing: 4) { legend }
            }
        }
        .padding(Layout.cardPadding)
        .surface()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Activity in the last 30 days, \(ActivityHistory.activeDays) active days")
    }

    private var legend: some View {
        ForEach(1...3, id: \.self) { level in
            HStack(spacing: 4) {
                Circle().fill(color(for: level)).frame(width: 4, height: 4)
                Text(level == 1 ? "1 activity" : level == 2 ? "2" : "3+")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize()
            }
        }
    }

    private func color(for level: Int) -> Color {
        switch level {
        case 0: Color(.tertiarySystemFill)
        case 1: MetricDomain.vitals.ringEnd
        case 2: MetricDomain.vitals.ringStart
        default: MetricDomain.cardio.ringStart
        }
    }
}

#Preview {
    ActivityGridCard().padding().pageBackground()
}
