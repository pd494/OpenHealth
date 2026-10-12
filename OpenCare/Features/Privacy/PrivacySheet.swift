import SwiftUI

struct PrivacySheet: View {
    private static let sections: [(title: String, body: String)] = [
        ("What OpenCare reads",
         "With your permission, OpenCare reads steps, sleep, heart rate variability, resting heart rate, and Fitbit Air sync status from Google Health. If you connect Apple Health, it reads the matching Health categories and hydration."),
        ("How it uses the data",
         "OpenCare uses these values for your rings, step and hydration widgets, and answers to questions you ask. The optional Apple Foundation Models answer runs on your device when available. OpenCare does not send your health data to an OpenCare server."),
        ("What stays on your device",
         "Google OAuth tokens are stored in the iPhone Keychain. Widget totals and goals are stored locally in an App Group shared only with OpenCare’s widget. Disconnecting Google Health removes its stored tokens. Uninstalling OpenCare removes its local data. Water already saved in Apple Health stays there until you remove it in Health."),
        ("Google Health limited use",
         "OpenCare’s use of information received from the Google Health API follows the Google Health API Developer and User Data Policy, including its Limited Use requirements. OpenCare does not sell health data or use it for advertising.")
    ]

    var body: some View {
        SheetContainer(title: "Privacy") {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(Self.sections, id: \.title) { section in
                        Text(section.title).font(.headline)
                        Text(section.body)
                    }
                    Text("Questions: prasanthdendukuri@gmail.com")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(Layout.sheetPadding)
            }
        }
    }
}

#Preview {
    PrivacySheet()
}
