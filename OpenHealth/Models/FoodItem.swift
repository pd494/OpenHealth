/// One food at a stated serving. Placeholder data until a food source is wired in.
struct FoodItem: Identifiable, Hashable {
    let name: String
    let serving: String
    let emoji: String
    let kcal: Int
    let protein: Int
    let carbs: Int
    let fat: Int

    var id: String { name }
}

extension FoodItem {
    static let greekYogurt = FoodItem(name: "Greek yogurt", serving: "1 serving (100 g)", emoji: "🥣", kcal: 97, protein: 9, carbs: 4, fat: 5)
    static let chicken = FoodItem(name: "Chicken breast, grilled", serving: "180 g", emoji: "🍗", kcal: 297, protein: 56, carbs: 0, fat: 6)
    static let rice = FoodItem(name: "White rice, cooked", serving: "1.5 cup", emoji: "🍚", kcal: 308, protein: 6, carbs: 67, fat: 1)
    static let broccoli = FoodItem(name: "Broccoli", serving: "1 cup", emoji: "🥦", kcal: 35, protein: 3, carbs: 7, fat: 0)
    static let avocado = FoodItem(name: "Avocado", serving: "½ fruit", emoji: "🥑", kcal: 130, protein: 2, carbs: 7, fat: 12)
    static let egg = FoodItem(name: "Egg, large", serving: "1 egg", emoji: "🥚", kcal: 74, protein: 6, carbs: 0, fat: 5)
    static let apple = FoodItem(name: "Apple", serving: "1 medium", emoji: "🍎", kcal: 95, protein: 0, carbs: 25, fat: 0)
    static let almonds = FoodItem(name: "Almonds", serving: "1 oz", emoji: "🌰", kcal: 115, protein: 4, carbs: 4, fat: 10)

    /// What the search sheet suggests before anything is typed.
    static let recents: [FoodItem] = [.greekYogurt, .chicken, .avocado, .egg, .rice]
}
