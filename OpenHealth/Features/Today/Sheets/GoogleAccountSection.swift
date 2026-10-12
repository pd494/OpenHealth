import SwiftUI

struct GoogleAccountSection: View {
    @Environment(GoogleHealthManager.self) private var google

    private static let setupGuideURL = URL(string: "https://developers.google.com/health/setup")!

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            if !google.isConfigured {
                Label("Google account connection needs a Google Cloud OAuth client ID for this build.", systemImage: "key")
                    .font(.subheadline)
                    .foregroundStyle(.orange)
                Link("Google Health setup guide", destination: Self.setupGuideURL)
                Text("To use Fitbit Air without Google Cloud setup, open Google Health → Partner apps → Apple Health and share Steps and Sleep. Then connect Apple Health below.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else if google.isConnected {
                Label("Google Health connected", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                Button("Check for new Fitbit data", action: sync)
                    .buttonStyle(.borderedProminent)
                Button("Reconnect Google Health", action: connect)
                Button("Disconnect Google Health", role: .destructive, action: google.disconnect)
                Divider()
                FasterStepsSection()
            } else {
                Button("Sign in with Google Health", action: connect)
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
            }
        }
    }

    private func connect() {
        Task { await google.connect() }
    }

    private func sync() {
        Task { await google.sync(force: true) }
    }
}
