struct Meal: Identifiable {
    let kind: MealKind
    /// Minutes after midnight.
    let startMinute: Int
    let items: [FoodItem]

    var id: String { "\(kind.title)-\(startMinute)" }
    var kcal: Int { items.reduce(0) { $0 + $1.kcal } }
    var summary: String { items.map(\.name).formatted(.list(type: .and, width: .narrow)) }
}

extension Meal {
    /// Today's meals so far. Calories add up to the placeholder "Cal in" metric.
    static let today: [Meal] = [
        Meal(kind: .breakfast, startMinute: 8 * 60 + 10, items: [
            .greekYogurt,
            FoodItem(name: "Blueberries", serving: "½ cup", emoji: "🫐", kcal: 84, protein: 1, carbs: 21, fat: 0),
            FoodItem(name: "Honey", serving: "1 tbsp", emoji: "🍯", kcal: 64, protein: 0, carbs: 17, fat: 0),
            FoodItem(name: "Granola", serving: "⅓ cup", emoji: "🥣", kcal: 175, protein: 4, carbs: 28, fat: 6),
            FoodItem(name: "Oat milk latte", serving: "12 oz", emoji: "☕️", kcal: 100, protein: 3, carbs: 14, fat: 4),
        ]),
        Meal(kind: .lunch, startMinute: 12 * 60 + 30, items: [.chicken, .rice, .broccoli]),
        Meal(kind: .snack, startMinute: 15 * 60, items: [.apple, .almonds]),
        Meal(kind: .snack, startMinute: 16 * 60 + 15, items: [
            FoodItem(name: "Protein bar", serving: "1 bar", emoji: "🍫", kcal: 270, protein: 20, carbs: 28, fat: 9),
        ]),
    ]
}
