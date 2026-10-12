import SwiftUI

struct GoogleStatusCard: View {
    @Environment(GoogleHealthManager.self) private var google
    @Binding var sheet: TodaySheet?

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "waveform.path.ecg")
                .font(.title3)
                .foregroundStyle(Palette.green)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 3) {
                Text(google.airName.map { "\($0) paired" } ?? "Google Health wearables")
                    .font(.subheadline.bold())
                Group {
                    if let synced = google.lastAirSync {
                        Text("Air synced \(synced, format: .dateTime.month(.abbreviated).day().hour().minute())")
                    } else {
                        Text("Fitbit Air not confirmed · steps from wearables")
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
            Button("Check Google Health now", systemImage: "arrow.clockwise", action: sync)
                .iconOnlyButton()
                .disabled(google.isSyncing)
            Button("Google Health connection settings", systemImage: "ellipsis") { sheet = .googleConnection }
                .iconOnlyButton()
        }
        .card()
    }

    private func sync() {
        Task { await google.sync(force: true) }
    }
}
