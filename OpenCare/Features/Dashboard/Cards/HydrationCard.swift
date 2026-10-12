import SwiftUI

struct HydrationCard: View {
    @Environment(HealthManager.self) private var health
    @Binding var sheet: DashboardSheet?

    var body: some View {
        HStack(spacing: 16) {
            Button("Add water", systemImage: "plus") { sheet = .water }
                .labelStyle(.iconOnly)
                .font(.rounded(.title2, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 52, height: 52)
                .background(Palette.progress(health.waterProgress), in: .circle)

            VStack(alignment: .leading, spacing: 7) {
                Label("Hydration", systemImage: "drop.fill")
                    .font(.rounded(.headline))
                Text("\(Int(health.waterOunces.rounded())) of \(Int(health.waterGoal)) oz")
                    .font(.rounded(.title2, weight: .bold))
                Text("\(health.waterProgress, format: .percent.precision(.fractionLength(0))) of daily goal")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
            ProgressRing(ratio: health.waterProgress, lineWidth: 9)
                .frame(width: 56, height: 56)
        }
        .card()
    }
}
