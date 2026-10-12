import SwiftUI

struct ConnectionCard: View {
    @Environment(HealthManager.self) private var health
    @Binding var sheet: TodaySheet?

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Connect your health data", systemImage: "heart.text.square")
                .font(.headline)
            Text("Connect Fitbit Air through Google Health, or use your iPhone and Apple Watch through Apple Health.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            HStack(spacing: 10) {
                Button("Connect Google Health") { sheet = .googleConnection }
                    .buttonStyle(.borderedProminent)
                    .tint(Palette.green)
                Button("Apple Health", action: connectAppleHealth)
                    .buttonStyle(.bordered)
            }
            Button("Preview with sample data", action: health.loadDemo)
                .font(.caption.weight(.medium))
        }
        .card()
    }

    private func connectAppleHealth() {
        Task { await health.connect() }
    }
}
