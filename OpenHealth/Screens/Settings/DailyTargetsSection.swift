import SwiftUI

struct DailyTargetsSection: View {
    @State private var calories = MetricID.caloriesIn.descriptor.goal
    @State private var protein = MetricID.protein.descriptor.goal
    @State private var carbs = MetricID.carbs.descriptor.goal
    @State private var fat = MetricID.fat.descriptor.goal
    @State private var water = MetricID.hydration.descriptor.goal

    var body: some View {
        Section("Daily targets") {
            GoalField(title: "Calories", unit: "kcal", value: $calories)
            GoalField(title: "Protein", unit: "g", value: $protein)
            GoalField(title: "Carbs", unit: "g", value: $carbs)
            GoalField(title: "Fat", unit: "g", value: $fat)
            GoalField(title: "Water", unit: "oz", value: $water)
        }
    }
}

#Preview {
    Form { DailyTargetsSection() }
}
