import SwiftUI

struct MealKindMenu: View {
    @Binding var meal: MealKind
    var body: some View {
        Menu {
            Picker("Meal", selection: $meal) {
                ForEach(MealKind.allCases, id: \.self) { Text($0.title).tag($0) }
            }
        } label: {
            HStack(spacing: 4) {
                Text(meal.title)
                Image(systemName: "chevron.down").imageScale(.small)
            }
            .font(.subheadline.weight(.semibold))
            .frame(minHeight: Layout.minTapTarget)
        }
    }
}
#Preview { MealKindMenu(meal: .constant(.lunch)) }
