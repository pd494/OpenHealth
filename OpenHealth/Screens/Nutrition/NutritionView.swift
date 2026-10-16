import SwiftUI

struct NutritionView: View {
    @Environment(\.presentLog) private var presentLog

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                DayStepper()
                CalorieSummaryCard()
                MealList()
                WaterCard()
            }
            .padding(.horizontal, Layout.screenPadding)
        }
        .pageBackground()
        .navigationTitle("Nutrition")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Log") { presentLog(.food) }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .controlSize(.small)
            }
        }
    }
}

#Preview {
    NavigationStack { NutritionView() }
}
