import SwiftUI

struct MealList: View {
    @Environment(\.presentLog) private var presentLog

    private let calories = MetricID.caloriesIn.descriptor

    var body: some View {
        VStack(spacing: 12) {
            ForEach(Meal.today) { meal in
                MealRow(meal: meal)
                Hairline(axis: .horizontal)
            }
            dinnerRow
        }
        .padding(Layout.cardPadding)
        .frame(maxWidth: .infinity)
        .surface()
    }

    private var dinnerRow: some View {
        Button {
            presentLog(.food)
        } label: {
            HStack(spacing: 12) {
                MealIconTile(symbol: MealKind.dinner.symbol)
                VStack(alignment: .leading, spacing: 2) {
                    Text(MealKind.dinner.title)
                        .font(.subheadline.bold())
                        .foregroundStyle(.primary)
                    Text("About \(Int(calories.goal - calories.value)) kcal left")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 8)
                Image(systemName: "plus.circle")
                    .font(.title3)
                    .foregroundStyle(MetricDomain.nutrition.ringStart)
                    .accessibilityHidden(true)
            }
            .frame(minHeight: Layout.minTapTarget)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Logs dinner")
    }
}

#Preview {
    MealList()
        .padding()
        .background(Palette.background)
}
