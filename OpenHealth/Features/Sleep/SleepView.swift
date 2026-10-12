import Inject
import SwiftUI

struct SleepView: View {
    @ObserveInjection private var inject
    @Environment(HealthManager.self) private var health

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Last night").font(.subheadline).foregroundStyle(.secondary)
                    Text("Sleep").font(.rounded(.largeTitle, weight: .bold)).tracking(-0.8)
                }
                if health.value(.sleep).value == nil {
                    EmptyState(
                        title: "No sleep recorded",
                        message: "Wear your watch to bed or connect a source to see last night.",
                        systemImage: "moon.zzz"
                    )
                } else {
                    SleepSummaryCard(value: health.value(.sleep), night: health.sleepNight)
                    if let night = health.sleepNight {
                        HypnogramChart(night: night)
                        SleepStagesCard(night: night)
                    }
                    if !health.sleepWeek.isEmpty {
                        SleepWeekChart(week: health.sleepWeek, goal: health.sleepGoal)
                    }
                }
            }
            .padding(Layout.screenPadding)
        }
        .background(Palette.background)
        .enableInjection()
    }
}

#Preview {
    SleepView().environment(HealthManager.preview)
}
