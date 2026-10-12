import SwiftUI

struct WaterSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(HealthManager.self) private var health
    @State private var amount = 8.0

    private static let quickAmounts = [8, 12, 16, 24]

    var body: some View {
        SheetContainer(title: "Log hydration") {
            VStack(alignment: .leading, spacing: 20) {
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
                HStack {
                    ForEach(Self.quickAmounts, id: \.self) { ounces in
                        Button("\(ounces) oz") { amount = Double(ounces) }
                            .buttonStyle(.bordered)
                    }
                }
                Button("Add water", action: add)
                    .buttonStyle(.borderedProminent)
                    .tint(Palette.green)
                    .frame(maxWidth: .infinity)
                Spacer()
            }
            .padding(Layout.sheetPadding)
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
