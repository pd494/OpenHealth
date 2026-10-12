import Inject
import SwiftUI

struct StressView: View {
    @ObserveInjection private var inject
    @Environment(HealthManager.self) private var health

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(Date.now, format: .dateTime.weekday(.wide).month(.wide).day())
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("Stress").font(.rounded(.largeTitle, weight: .bold)).tracking(-0.8)
                }
                if let day = health.stressDay, !day.points.isEmpty {
                    todayCard(day)
                    StressBandsCard(day: day)
                    StressTrendCard(day: day)
                } else {
                    EmptyState(
                        title: "No stress data yet",
                        message: "Stress needs heart rate and HRV from Apple Health or a connected watch.",
                        systemImage: "brain.head.profile"
                    )
                }
            }
            .padding(Layout.screenPadding)
        }
        .background(Palette.background)
        .enableInjection()
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
    }

    private func todayCard(_ day: StressDay) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline) {
                Text("Today's stress").cardTitle()
                Spacer()
                if let current = day.current {
                    Label(current.band.title, systemImage: "circle.fill")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(current.band.color)
                }
            }
            StressChart(day: day)
        }
        .card()
    }
}

#Preview {
    NavigationStack { StressView() }
        .environment(HealthManager.preview)
}
