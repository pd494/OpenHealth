import SwiftUI

struct WorkoutRow: View {
    @Environment(\.dynamicTypeSize) private var typeSize

    let workout: Workout

    private static let tileSize = 40.0

    private var day: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(workout.start) { return "Today" }
        if calendar.isDateInYesterday(workout.start) { return "Yesterday" }
        return workout.start.formatted(.dateTime.weekday())
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: workout.kind.symbol)
                .font(.title3)
                .foregroundStyle(MetricDomain.activity.adaptiveLabel)
                .frame(width: Self.tileSize, height: Self.tileSize)
                .background(MetricDomain.activity.ringEnd.opacity(0.2), in: .rect(cornerRadius: Layout.pillRadius))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.kind.title)
                    .font(.subheadline.weight(.semibold))
                Text("\(day), \(workout.start, format: .dateTime.hour().minute()) · \(workout.minutes, format: .number) min")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                if typeSize.isAccessibilitySize { source }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            if !typeSize.isAccessibilitySize { source }
        }
        .padding(.vertical, 12)
        .accessibilityElement(children: .combine)
    }

    private var source: some View {
        Text(workout.source.title)
            .textCase(.uppercase)
            .font(.caption2)
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    WorkoutRow(workout: Workout.recent[0]).padding().pageBackground()
}
