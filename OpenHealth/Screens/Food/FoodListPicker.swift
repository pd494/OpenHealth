import SwiftUI

struct FoodListPicker: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    @Binding var selection: FoodListTab
    var body: some View {
        Group {
            if typeSize.isAccessibilitySize { picker.pickerStyle(.menu) }
            else { picker.pickerStyle(.segmented) }
        }
        .frame(minHeight: Layout.minTapTarget)
    }
    private var picker: some View {
        Picker("Foods", selection: $selection) {
            ForEach(FoodListTab.allCases, id: \.self) { Text($0.rawValue).tag($0) }
        }
    }
}
#Preview { FoodListPicker(selection: .constant(.recent)).padding() }
