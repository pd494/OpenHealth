import SwiftUI

struct GoalsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(HealthManager.self) private var health
    @State private var steps = 0
    @State private var sleep = 0.0
    @State private var water = 0.0

    var body: some View {
        SheetContainer(title: "Daily goals") {
            Form {
                LabeledContent("Steps") {
                    TextField("Steps", value: $steps, format: .number).keyboardType(.numberPad)
                }
                LabeledContent("Sleep hours") {
                    TextField("Hours", value: $sleep, format: .number).keyboardType(.decimalPad)
                }
                LabeledContent("Water oz") {
                    TextField("Ounces", value: $water, format: .number).keyboardType(.decimalPad)
                }
                Button("Save goals", action: save)
            }
            .multilineTextAlignment(.trailing)
            .onAppear {
                steps = health.stepGoal
                sleep = health.sleepGoal
                water = health.waterGoal
            }
        }
    }

    /// Non-positive entries leave the existing goal unchanged.
    private func save() {
        if steps > 0 { health.stepGoal = steps }
        if sleep > 0 { health.sleepGoal = sleep }
        if water > 0 { health.waterGoal = water }
        dismiss()
    }
}

#Preview {
    GoalsSheet()
        .environment(HealthManager.preview)
}
