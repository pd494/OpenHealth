import SwiftUI

struct ActivityTargetsSection: View {
    @State private var steps = MetricID.steps.descriptor.goal
    @State private var exercise = MetricID.exerciseMinutes.descriptor.goal
    @State private var sleepHours = Int(MetricID.sleep.descriptor.goal)
    @State private var units = UnitSystem.us

    var body: some View {
        Section("Activity and sleep") {
            GoalField(title: "Steps", unit: "steps", value: $steps)
            GoalField(title: "Exercise", unit: "min", value: $exercise)
            Stepper(value: $sleepHours, in: 4...12) {
                LabeledContent("Sleep") {
                    Text("\(sleepHours, format: .number)h")
                }
            }
            Picker("Units", selection: $units) {
                ForEach(UnitSystem.allCases, id: \.self) { Text($0.rawValue) }
            }
            .pickerStyle(.menu)
        }
    }
}

#Preview {
    Form { ActivityTargetsSection() }
}
