import SwiftUI

struct LogActivityView: View {
    @State private var kind = ActivityKind.walk
    @State private var start = Date.now
    @State private var minutes = 30
    @State private var intensity = 5.0

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ActivityKindPicker(selection: $kind)
                ActivityDetailsCard(start: $start, minutes: $minutes)
                IntensityCard(intensity: $intensity)
                Text("Saved to Google Health and shown on Today and Fitness.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(Layout.screenPadding)
        }
        .pageBackground()
        .navigationTitle("Log activity")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) { LogConfirmButton(title: "Add to log") }
    }
}

#Preview { NavigationStack { LogActivityView() } }
