import SwiftUI

struct GoalField: View {
    let title: LocalizedStringKey
    let unit: String
    @Binding var value: Double

    var body: some View {
        LabeledContent(title) {
            HStack(spacing: 4) {
                TextField(title, value: $value, format: .number)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
                Text(unit)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    Form {
        GoalField(title: "Calories", unit: "kcal", value: .constant(2_000))
    }
}
