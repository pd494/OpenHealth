import SwiftUI

struct LogFoodView: View {
    @State private var query = ""
    @State private var tab = FoodListTab.recent
    @State private var meal = MealKind.lunch
    @State private var selection: Set<FoodItem.ID> = []
    @State private var showsConfirm = DebugLaunch.string("foodRoute") == "confirm"

    private var foods: [FoodItem] {
        FoodItem.recents.filter { query.isEmpty || $0.name.localizedStandardContains(query) }
    }
    private var selectedFoods: [FoodItem] { FoodItem.recents.filter { selection.contains($0.id) } }

    var body: some View {
        let foods = foods
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                FoodShortcuts()
                SameAsYesterdayCard()
                FoodListPicker(selection: $tab)
                VStack(spacing: 0) {
                    ForEach(foods) { food in
                        if food.id != foods[0].id { Hairline(axis: .horizontal).padding(.horizontal, 16) }
                        FoodRow(food: food, isSelected: selection.contains(food.id)) { toggle(food) }
                    }
                }
                .surface()
                if foods.isEmpty { ContentUnavailableView.search(text: query) }
            }
            .padding(Layout.screenPadding)
        }
        .pageBackground()
        .navigationTitle("Log food")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search foods or brands")
        .toolbar { ToolbarItem(placement: .topBarTrailing) { MealKindMenu(meal: $meal) } }
        .safeAreaInset(edge: .bottom) {
            if !selection.isEmpty { LogBar(foods: selectedFoods, meal: meal).padding(16) }
        }
        .navigationDestination(isPresented: $showsConfirm) { ConfirmMealView() }
    }

    private func toggle(_ food: FoodItem) {
        if selection.contains(food.id) { selection.remove(food.id) } else { selection.insert(food.id) }
    }
}

#Preview { NavigationStack { LogFoodView() } }
