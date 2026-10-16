import SwiftUI

struct LogBar: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var typeSize
    let foods: [FoodItem]
    let meal: MealKind
    private var calories: Int { foods.reduce(0) { $0 + $1.kcal } }
    var body: some View {
        let layout = typeSize.isAccessibilitySize ? AnyLayout(VStackLayout(spacing: 8)) : AnyLayout(HStackLayout(spacing: 12))
        layout {
            VStack(alignment: .leading, spacing: 4) {
                Text("^[\(foods.count) food](inflect: true) · \(calories, format: .number) kcal")
                    .font(.subheadline).bold()
                Text("\(meal.title) · 12:30 PM").font(.caption).foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityElement(children: .combine)
            Button { dismiss() } label: {
                Text("Log").font(.subheadline).bold().foregroundStyle(.white)
                    .padding(.horizontal, 24).frame(minHeight: Layout.minTapTarget)
                    .background(.black, in: .capsule)
            }
        }
        .padding(12)
        .background {
            if typeSize.isAccessibilitySize {
                RoundedRectangle(cornerRadius: Layout.cardRadius).fill(Palette.card)
            } else {
                Capsule().fill(Palette.card)
            }
        }
        .shadow(color: .black.opacity(0.14), radius: 12, y: 6)
    }
}
#Preview { LogBar(foods: [.greekYogurt, .chicken], meal: .lunch).padding().pageBackground() }
