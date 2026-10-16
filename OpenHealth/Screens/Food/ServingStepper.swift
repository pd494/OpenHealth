import SwiftUI

struct ServingStepper: View {
    let foodName: String
    let unit: String
    let step: Double
    @Binding var amount: Double
    var body: some View {
        HStack(spacing: 0) {
            Button(action: decrease) {
                Label("Decrease serving", systemImage: "minus")
                    .frame(minWidth: Layout.minTapTarget, minHeight: Layout.minTapTarget)
            }
            .disabled(amount <= step)
            Text("\(amount, format: .number.precision(.fractionLength(0...1))) \(unit)")
                .font(.footnote.weight(.semibold)).monospacedDigit().fixedSize()
            Button(action: increase) {
                Label("Increase serving", systemImage: "plus")
                    .frame(minWidth: Layout.minTapTarget, minHeight: Layout.minTapTarget)
            }
        }
        .buttonStyle(.borderless).labelStyle(.iconOnly)
        .font(.subheadline.weight(.semibold))
        .background(Palette.background, in: .capsule)
        .accessibilityRepresentation {
            Stepper("\(foodName) serving", onIncrement: increase, onDecrement: decrease)
                .accessibilityValue("\(amount.formatted()) \(unit)")
        }
    }
    private func decrease() { amount = max(step, amount - step) }
    private func increase() { amount += step }
}
#Preview { ServingStepper(foodName: "Chicken", unit: "g", step: 10, amount: .constant(180)) }
