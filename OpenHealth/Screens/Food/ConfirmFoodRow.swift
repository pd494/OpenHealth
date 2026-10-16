import SwiftUI

struct ConfirmFoodRow: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    let food: FoodItem
    let unit: String
    let step: Double
    @State private var isIncluded = true
    @State private var amount: Double
    init(food: FoodItem, amount: Double, unit: String, step: Double) {
        self.food = food
        self.unit = unit
        self.step = step
        _amount = State(initialValue: amount)
    }
    var body: some View {
        let layout = typeSize.isAccessibilitySize ? AnyLayout(VStackLayout(alignment: .leading, spacing: 8)) : AnyLayout(HStackLayout(spacing: 4))
        layout {
            Toggle(isOn: $isIncluded) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(food.name).font(.subheadline.weight(.semibold))
                    Text("\(amount, format: .number.precision(.fractionLength(0...1))) \(unit) · \(food.kcal, format: .number) kcal")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                .fixedSize(horizontal: false, vertical: true)
            }
            .toggleStyle(CheckToggleStyle())
            ServingStepper(foodName: food.name, unit: unit, step: step, amount: $amount)
        }
        .padding(.vertical, 12)
    }
}
#Preview { ConfirmFoodRow(food: .chicken, amount: 180, unit: "g", step: 10).padding().surface() }
