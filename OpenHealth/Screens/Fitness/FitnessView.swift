import SwiftUI

struct FitnessView: View {
    @Environment(\.presentLog) private var presentLog

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Last 30 days")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                ActivityGridCard()
                ActivitySummaryCard()
                FitnessStatPair()
                Text("Workouts")
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)
                    .padding(.top, 12)
                WorkoutList()
            }
            .padding(.horizontal, Layout.screenPadding)
            .padding(.vertical, 12)
        }
        .debugScrollAnchor()
        .pageBackground()
        .navigationTitle("Fitness")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Log") { presentLog(.activity) }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .controlSize(.small)
                    .frame(minWidth: Layout.minTapTarget, minHeight: Layout.minTapTarget)
            }
        }
    }
}

#Preview {
    NavigationStack { FitnessView() }
}

#Preview("Largest text") {
    NavigationStack { FitnessView() }
        .environment(\.dynamicTypeSize, .accessibility5)
}
