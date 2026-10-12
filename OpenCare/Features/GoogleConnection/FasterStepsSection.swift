import SwiftUI

struct FasterStepsSection: View {
    @Environment(HealthManager.self) private var health

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Label("Faster step widget", systemImage: "figure.walk.motion")
                .font(.headline)
            Text("OpenCare can watch for Fitbit steps shared into Apple Health, then fetch Google's step total for the widget.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            if health.googleStepWakeupsEnabled {
                let detected = health.googleStepShareDetected
                Label(
                    detected ? "Google Health step sharing detected" : "Waiting for shared steps",
                    systemImage: detected ? "checkmark.circle.fill" : "clock"
                )
                .font(.subheadline)
                .foregroundStyle(detected ? Color.green : Color.secondary)
            } else {
                Button("Enable faster step updates", action: enable)
                    .buttonStyle(.borderedProminent)
            }
            Text("In Google Health, open Connections → Apps & services (or Partner apps) → Apple Health and share Steps. Then allow OpenCare to read Steps.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func enable() {
        Task { await health.enableGoogleStepWakeups() }
    }
}
