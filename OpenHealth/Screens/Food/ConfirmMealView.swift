import SwiftUI

struct ConfirmMealView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var typeSize
    @State private var meal = MealKind.lunch
    @State private var time = Calendar.current.startOfDay(for: .now).addingTimeInterval(12.5 * 60 * 60)
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                MealPhotoPlaceholder()
                MealNutritionCard()
                VStack(spacing: 0) {
                    ConfirmFoodRow(food: .chicken, amount: 180, unit: "g", step: 10)
                    Hairline(axis: .horizontal)
                    ConfirmFoodRow(food: .rice, amount: 1.5, unit: "cup", step: 0.5)
                    Hairline(axis: .horizontal)
                    ConfirmFoodRow(food: .broccoli, amount: 1, unit: "cup", step: 0.5)
                    Hairline(axis: .horizontal)
                    Toggle(isOn: .constant(false)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Olive oil").font(.subheadline.weight(.semibold))
                            Text("Not detected").font(.footnote)
                        }
                    }
                    .toggleStyle(CheckToggleStyle()).disabled(true).foregroundStyle(.secondary).padding(.vertical, 12)
                }
                .padding(.horizontal, 12).surface()
                let layout = typeSize.isAccessibilitySize ? AnyLayout(VStackLayout(alignment: .leading, spacing: 8)) : AnyLayout(HStackLayout(spacing: 8))
                layout {
                    MealKindMenu(meal: $meal).padding(.horizontal, 12).surface(radius: Layout.pillRadius)
                    DatePicker("Meal time", selection: $time, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.compact).labelsHidden()
                        .frame(minHeight: Layout.minTapTarget)
                    Spacer(minLength: 0)
                }
            }
            .padding(Layout.screenPadding)
        }
        .pageBackground()
        .navigationTitle("Review meal").navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Button { dismiss() } label: {
                Text("Log meal").font(.headline).foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: Layout.minTapTarget).padding(8)
                    .background(.black, in: .capsule)
            }
            .padding(16).background(Palette.background)
        }
    }
}
#Preview { NavigationStack { ConfirmMealView() } }
