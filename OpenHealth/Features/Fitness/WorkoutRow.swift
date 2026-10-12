import SwiftUI

struct WorkoutRow: View {
    let workout: WorkoutSummary

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: workout.systemImage)
                .foregroundStyle(Palette.activity)
                .frame(width: 40, height: 40)
                .background(Palette.activity.opacity(0.14), in: .circle)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(workout.name).font(.subheadline.weight(.semibold))
                Text(workout.start, format: .dateTime.weekday(.wide).hour().minute())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 8)
            VStack(alignment: .trailing, spacing: 2) {
                Text(Duration.seconds(workout.duration).formatted(.units(allowed: [.hours, .minutes], width: .narrow)))
                    .metricNumber(.subheadline)
                Text(detail).font(.caption).foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
    }

    private var detail: String {
        [
            workout.miles.map { "\($0.formatted(.number.precision(.fractionLength(1)))) mi" },
            workout.calories.map { "\($0.formatted(.number.precision(.fractionLength(0)))) kcal" }
        ].compactMap { $0 }.joined(separator: " · ")
    }
}
