import Inject
import SwiftUI

struct FitnessView: View {
    @ObserveInjection private var inject
    @Environment(HealthManager.self) private var health

    private static let today: [MetricID] = [.steps, .distance, .activeEnergy, .exerciseMinutes]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(Date.now, format: .dateTime.weekday(.wide).month(.wide).day())
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("Fitness").font(.rounded(.largeTitle, weight: .bold)).tracking(-0.8)
                }
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: Layout.tileSpacing), count: 2),
                    spacing: Layout.tileSpacing
                ) {
                    ForEach(Self.today, id: \.self) { id in
                        MetricTile(value: health.value(id), layout: .grid, showsHandle: false)
                            .frame(height: Layout.gridTileHeight)
                    }
                }
                FitnessTrendCard()
                workouts
            }
            .padding(Layout.screenPadding)
        }
        .background(Palette.background)
        .enableInjection()
    }

    private var workouts: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Workouts").eyebrow()
            if health.workouts.isEmpty {
                EmptyState(
                    title: "No workouts yet",
                    message: "Workouts recorded in Apple Health will show up here.",
                    systemImage: "figure.run"
                )
            } else {
                VStack(spacing: 14) {
                    ForEach(Array(health.workouts.enumerated()), id: \.element.id) { index, workout in
                        if index > 0 { Hairline() }
                        WorkoutRow(workout: workout)
                    }
                }
                .card()
            }
        }
    }
}

#Preview {
    FitnessView().environment(HealthManager.preview)
}
