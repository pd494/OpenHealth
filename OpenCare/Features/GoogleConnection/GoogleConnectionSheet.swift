import SwiftUI

struct GoogleConnectionSheet: View {
    @Environment(HealthManager.self) private var health
    @State private var showingPrivacy = false

    var body: some View {
        SheetContainer(title: "Google Health") {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("Fitbit Air in OpenCare")
                        .font(.title.bold())
                    Text("Sign in to the Google account paired with your Fitbit Air. OpenCare reads wearable steps, sleep and vitals from Google Health.")
                        .foregroundStyle(.secondary)
                    Button("How OpenCare uses your health data") { showingPrivacy = true }
                        .font(.subheadline)
                    GoogleAccountSection()
                    Divider()
                    Button("Connect Apple Health instead", action: connectAppleHealth)
                        .font(.subheadline)
                }
                .padding(Layout.sheetPadding)
            }
        }
        .sheet(isPresented: $showingPrivacy) { PrivacySheet() }
    }

    private func connectAppleHealth() {
        Task { await health.connect() }
    }
}

#Preview {
    GoogleConnectionSheet()
        .environment(HealthManager.preview)
        .environment(GoogleHealthManager.shared)
}
