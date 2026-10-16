import SwiftUI

struct WeekStrip: View {
    private static let dots: [[MetricDomain]] = [
        [.activity, .nutrition], [.activity, .sleep], [.sleep],
        [.activity, .nutrition, .sleep], [.activity, .nutrition, .sleep], [], []
    ]
    private static let circleSize = 32.0
    private static let dotSize = 4.0

    @Binding var selection: Date
    @ScaledMetric(relativeTo: .subheadline) private var scaledCircleSize = Self.circleSize

    private var days: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let weekday = calendar.component(.weekday, from: today) - 1
        let sunday = calendar.date(byAdding: .day, value: -weekday, to: today)!
        return (0..<7).map { calendar.date(byAdding: .day, value: $0, to: sunday)! }
    }

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { date in
                    dayButton(date)
                        .frame(maxWidth: .infinity)
                }
            }
            .containerRelativeFrame(.horizontal) { width, _ in
                max(width, 7 * max(Layout.minTapTarget, scaledCircleSize))
            }
        }
        .scrollIndicators(.hidden)
        .sensoryFeedback(.selection, trigger: selection)
    }

    private func dayButton(_ date: Date) -> some View {
        let selected = Calendar.current.isDate(date, inSameDayAs: selection)
        let weekday = Calendar.current.component(.weekday, from: date) - 1
        return Button {
            selection = date
        } label: {
            VStack(spacing: 4) {
                Text(date, format: .dateTime.weekday(.narrow))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(date, format: .dateTime.day())
                    .font(.subheadline)
                    .foregroundStyle(selected ? Color(.systemBackground) : .primary)
                    .frame(width: scaledCircleSize, height: scaledCircleSize)
                    .background(selected ? Color.primary : .clear, in: .circle)
                HStack(spacing: Self.dotSize) {
                    ForEach(Self.dots[weekday], id: \.self) { domain in
                        Circle()
                            .fill(domain.ringStart)
                            .frame(width: Self.dotSize, height: Self.dotSize)
                    }
                }
                .frame(height: Self.dotSize)
                .accessibilityHidden(true)
            }
            .frame(minWidth: Layout.minTapTarget, minHeight: Layout.minTapTarget)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(date.formatted(.dateTime.weekday(.wide).month().day()))
        .accessibilityAddTraits(selected ? .isSelected : [])
    }
}

#Preview {
    WeekStrip(selection: .constant(Calendar.current.startOfDay(for: .now)))
        .padding()
}
