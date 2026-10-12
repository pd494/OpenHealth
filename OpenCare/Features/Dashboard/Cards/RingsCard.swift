import SwiftUI

struct RingsCard: View {
    @Environment(HealthManager.self) private var health
    @Environment(GoogleHealthManager.self) private var google

    private var sleepText: String {
        let hours = Int(health.sleepHours)
        let minutes = Int((health.sleepHours - Double(hours)) * 60)
        return "\(hours)h \(minutes)m"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            HStack {
                Text("Your day")
                    .font(.rounded(.title3))
                Spacer()
                if health.isLoading || google.isSyncing { ProgressView().tint(Palette.green) }
            }
            HStack(alignment: .top, spacing: 4) {
                MetricRing(
                    title: "Steps",
                    value: health.steps.formatted(),
                    detail: "of \(health.stepGoal.formatted())",
                    ratio: health.stepsProgress,
                    systemName: "figure.walk"
                )
                MetricRing(
                    title: "Recovery",
                    value: health.recoveryScore.map { "\($0)%" } ?? "—",
                    detail: health.recoveryScore == nil ? "needs HR data" : "estimate",
                    ratio: Double(health.recoveryScore ?? 0) / 100,
                    systemName: "heart.fill"
                )
                MetricRing(
                    title: "Sleep",
                    value: sleepText,
                    detail: "\(health.sleepProgress.formatted(.percent.precision(.fractionLength(0)))) of goal",
                    ratio: health.sleepProgress,
                    systemName: "moon.stars.fill"
                )
            }
        }
        .card(radius: 28)
    }
}
