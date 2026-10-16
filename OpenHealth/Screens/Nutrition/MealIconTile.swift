import SwiftUI

struct MealIconTile: View {
    let symbol: String

    var body: some View {
        Image(systemName: symbol)
            .foregroundStyle(MetricDomain.nutrition.ringStart)
            .frame(width: 36, height: 36)
            .background(MetricDomain.nutrition.ringStart.opacity(0.12), in: .rect(cornerRadius: 10))
            .accessibilityHidden(true)
    }
}

#Preview {
    MealIconTile(symbol: MealKind.lunch.symbol)
}
