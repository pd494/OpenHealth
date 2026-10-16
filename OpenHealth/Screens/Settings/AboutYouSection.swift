import SwiftUI

struct AboutYouSection: View {
    @State private var weight = MetricID.weight.descriptor.value
    @State private var age = 27
    @State private var plan = WeightGoal.maintain

    var body: some View {
        Section("About you") {
            LabeledContent("Height") {
                Text("5′ 10″")
            }
            LabeledContent("Weight") {
                HStack(spacing: 4) {
                    TextField("Weight", value: $weight, format: .number.precision(.fractionLength(0...1)))
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                    Text("lb")
                        .foregroundStyle(.secondary)
                }
            }
            .accessibilityElement(children: .combine)
            LabeledContent("Age") {
                TextField("Age", value: $age, format: .number)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
            }
            Picker("Goal", selection: $plan) {
                ForEach(WeightGoal.allCases, id: \.self) { Text($0.rawValue) }
            }
            .pickerStyle(.menu)
        }
    }
}

#Preview {
    Form { AboutYouSection() }
}
