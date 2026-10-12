import SwiftUI

struct WaterSheet: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    @Environment(\.dismiss) private var dismiss
    @Environment(HealthManager.self) private var health
    @State private var amount = 8.0

    private static let quickAmounts = [8, 12, 16, 24]

    var body: some View {
        SheetContainer(title: "Log hydration") {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("How much water?")
                        .font(.largeTitle.bold())
                    HStack {
                        TextField("Ounces", value: $amount, format: .number)
                            .keyboardType(.decimalPad)
                            .font(.rounded(.largeTitle, weight: .bold))
                        Text("oz")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .inputSurface()
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: typeSize.isAccessibilitySize ? 2 : 4), spacing: 8) {
                        ForEach(Self.quickAmounts, id: \.self) { ounces in
                            Button("\(ounces) oz") { amount = Double(ounces) }
                                .buttonStyle(.bordered)
                        }
                    }
                    Button(action: add) {
                        Text("Add water").frame(maxWidth: .infinity, minHeight: Layout.minTapTarget)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .frame(maxWidth: .infinity)
                }
                .padding(Layout.sheetPadding)
            }
        }
    }

    private func add() {
        guard amount > 0 else { return }
        Task {
            await health.addWater(ounces: amount)
            if health.errorMessage == nil { dismiss() }
        }
    }
}

#Preview {
    WaterSheet()
        .environment(HealthManager.preview)
}
