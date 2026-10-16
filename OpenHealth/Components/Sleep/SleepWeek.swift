import SwiftUI

/// Hours asleep for each of the last seven nights against the goal line. Tonight's bar is the deepest.
struct SleepWeek: View {
    @ScaledMetric(relativeTo: .caption2) private var goalLabelSize = 9.0

    let hours: [Double]
    let goal: Double

    private static let barHeight = 112.0
    private static let goalLabelHeight = 14.0
    private static let ceiling = 9.0

    private var days: [Date] {
        let today = Calendar.current.startOfDay(for: .now)
        return hours.indices.map { Calendar.current.date(byAdding: .day, value: $0 - hours.count + 1, to: today)! }
    }

    private func barHeight(for value: Double) -> Double { Self.barHeight * value / Self.ceiling }

    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .bottom) {
                goalLine
                HStack(alignment: .bottom, spacing: 10) {
                    ForEach(hours.indices, id: \.self) { index in
                        Bar(hours: hours[index], height: barHeight(for: hours[index]), isLast: index == hours.count - 1)
                    }
                }
            }
            .frame(height: Self.barHeight + Self.goalLabelHeight)
            HStack(spacing: 10) {
                ForEach(hours.indices, id: \.self) { index in
                    VStack(spacing: 2) {
                        Text(hours[index], format: .number.precision(.fractionLength(1)))
                            .font(.caption2.weight(.semibold))
                            .monospacedDigit()
                            .foregroundStyle(index == hours.count - 1 ? MetricDomain.sleep.ringLabel : Color.secondary)
                        Text(days[index], format: .dateTime.weekday(.narrow))
                            .font(.caption2.weight(index == hours.count - 1 ? .bold : .regular))
                            .foregroundStyle(index == hours.count - 1 ? Color.primary : Color.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .accessibilityHidden(true)
        }
        .accessibilityElement(children: .contain)
    }

    private var goalLine: some View {
        GoalLine()
            .stroke(Palette.sleepGuideLabel, style: StrokeStyle(lineWidth: 1, dash: [4, 3]))
            .frame(height: 1)
            .overlay(alignment: .trailing) {
                Text("\(goal, format: .number.precision(.fractionLength(0)))h goal")
                    .font(.system(size: goalLabelSize, weight: .bold))
                    .foregroundStyle(Palette.sleepGuideLabel)
                    .offset(y: -9)
            }
            .padding(.bottom, barHeight(for: goal))
            .accessibilityHidden(true)
    }
}

private struct Bar: View {
    let hours: Double
    let height: Double
    let isLast: Bool

    var body: some View {
        let sleep = MetricDomain.sleep
        Capsule()
            .fill(LinearGradient(
                colors: isLast ? [sleep.ringStart, sleep.ringDeep] : [sleep.ringEnd.opacity(0.7), sleep.ringEnd.opacity(0.7)],
                startPoint: .bottom, endPoint: .top
            ))
            .frame(height: height)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(isLast ? "Last night" : "Earlier night")
        .accessibilityValue(SleepNight.duration(Int(hours * 60)))
    }
}

private struct GoalLine: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        }
    }
}
