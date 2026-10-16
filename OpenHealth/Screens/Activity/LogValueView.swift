import SwiftUI

struct LogValueView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var typeSize
    let value: LogValue
    @State private var amount: Double

    private static let quickAmounts = [8, 12, 16, 24]

    init(value: LogValue) {
        self.value = value
        _amount = State(initialValue: value.defaultAmount)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: value.symbol)
                    .font(.largeTitle)
                    .foregroundStyle(value.domain.ringLabel)
                    .accessibilityHidden(true)
                let layout = typeSize.isAccessibilitySize ? AnyLayout(VStackLayout(spacing: 16)) : AnyLayout(HStackLayout(spacing: 24))
                layout {
                    adjustmentButton(increasing: false)
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text(amount, format: .number.precision(.fractionLength(value == .water ? 0 : 1)))
                            .font(.system(.largeTitle, weight: .bold))
                            .monospacedDigit()
                            .contentTransition(.numericText())
                        Text(value.unit).font(.title3).foregroundStyle(.secondary)
                    }
                    .accessibilityElement(children: .combine)
                    adjustmentButton(increasing: true)
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .surface()
                if value == .water {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: typeSize.isAccessibilitySize ? 120 : 64))], spacing: 8) {
                        ForEach(Self.quickAmounts, id: \.self) { addition in
                            Button { adjust(by: Double(addition)) } label: {
                                Text("+\(addition, format: .number) oz")
                                    .font(.subheadline.weight(.semibold))
                                    .frame(maxWidth: .infinity, minHeight: Layout.minTapTarget)
                                    .surface(radius: Layout.pillRadius)
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("Add \(addition) ounces")
                        }
                    }
                }
            }
            .padding(Layout.screenPadding)
        }
        .pageBackground()
        .navigationTitle(value.title)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) { LogConfirmButton(title: "Log") }
    }

    private func adjustmentButton(increasing: Bool) -> some View {
        Button(increasing ? "Increase amount" : "Decrease amount", systemImage: increasing ? "plus" : "minus") {
            adjust(by: increasing ? value.step : -value.step)
        }
        .labelStyle(.iconOnly)
        .font(.title2)
        .frame(minWidth: Layout.minTapTarget, minHeight: Layout.minTapTarget)
        .background(Palette.card, in: .circle)
        .buttonStyle(.plain)
        .disabled(!increasing && amount < value.step)
    }

    private func adjust(by change: Double) {
        withMotion(reduceMotion: reduceMotion) { amount = max(0, amount + change) }
    }
}

#Preview("Water") { NavigationStack { LogValueView(value: .water) } }
#Preview("Weight") { NavigationStack { LogValueView(value: .weight) } }
