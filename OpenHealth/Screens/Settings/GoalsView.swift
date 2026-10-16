import SwiftUI

struct GoalsView: View {
    var body: some View {
        Form {
            AboutYouSection()
            DailyTargetsSection()
            ActivityTargetsSection()
        }
        .scrollContentBackground(.hidden)
        .pageBackground()
        .navigationTitle("Goals")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { GoalsView() }
}
