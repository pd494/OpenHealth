import SwiftUI

struct FoodShortcuts: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    var body: some View {
        Group {
            if typeSize.isAccessibilitySize {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) { tiles }
            } else {
                HStack(spacing: 8) { tiles }
            }
        }
        .foregroundStyle(.primary)
        .buttonStyle(PressableButtonStyle())
    }
    private var tiles: some View {
        Group {
            Button {} label: { tile("Barcode", symbol: "barcode.viewfinder") }
            NavigationLink { ConfirmMealView() } label: { tile("Snap meal", symbol: "camera") }
            Button {} label: { tile("Describe", symbol: "text.bubble") }
            Button {} label: { tile("Quick add", symbol: "bolt") }
        }
    }
    private func tile(_ title: String, symbol: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: symbol).font(.title3).accessibilityHidden(true)
            Text(title).font(.caption.weight(.semibold)).multilineTextAlignment(.center)
        }
        .padding(8)
        .frame(maxWidth: .infinity, minHeight: 64)
        .surface(radius: Layout.pillRadius)
    }
}
#Preview { NavigationStack { FoodShortcuts().padding().pageBackground() } }
