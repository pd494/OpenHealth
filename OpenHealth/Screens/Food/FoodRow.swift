import SwiftUI

struct FoodRow: View {
    let food: FoodItem
    let isSelected: Bool
    let toggle: () -> Void
    var body: some View {
        Button(action: toggle) {
            HStack(spacing: 12) {
                Text(food.emoji).font(.title3)
                    .frame(width: 40, height: 40)
                    .background(MetricDomain.nutrition.ringStart.opacity(0.1), in: .rect(cornerRadius: Layout.pillRadius))
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 4) {
                    Text(food.name).font(.subheadline.weight(.semibold))
                    Label("\(food.kcal, format: .number) kcal · \(food.serving)", systemImage: "flame.fill")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 0)
                Image(systemName: isSelected ? "checkmark" : "plus")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(isSelected ? .white : Color.primary)
                    .frame(width: 32, height: 32)
                    .background(isSelected ? MetricDomain.nutrition.ringStart : Palette.background, in: .circle)
            }
            .padding(12).contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(food.name), \(food.kcal.formatted()) calories, \(food.serving)")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .sensoryFeedback(.selection, trigger: isSelected)
    }
}
#Preview { FoodRow(food: .greekYogurt, isSelected: false, toggle: {}).surface().padding() }
