import SwiftUI

struct MealRow: View {
    let meal: Meal

    private var time: Date {
        Calendar.current.date(bySettingHour: meal.startMinute / 60, minute: meal.startMinute % 60, second: 0, of: .now)!
    }

    var body: some View {
        HStack(spacing: 12) {
            MealIconTile(symbol: meal.kind.symbol)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(meal.kind.title) · \(Text(time, format: .dateTime.hour().minute()))")
                    .font(.subheadline.bold())
                Text(meal.summary)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            Spacer(minLength: 8)
            Text("\(meal.kcal) kcal")
                .font(.subheadline.bold())
                .monospacedDigit()
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    MealRow(meal: Meal.today[0]).padding()
}
