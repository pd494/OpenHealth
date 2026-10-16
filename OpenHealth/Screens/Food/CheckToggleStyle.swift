import SwiftUI

struct CheckToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button { configuration.isOn.toggle() } label: {
            HStack(spacing: 8) {
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                    .font(.title3).foregroundStyle(configuration.isOn ? MetricDomain.nutrition.ringStart : Color.secondary)
                    .frame(minWidth: Layout.minTapTarget, minHeight: Layout.minTapTarget)
                    .accessibilityHidden(true)
                configuration.label
                Spacer(minLength: 0)
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityRepresentation { Toggle(isOn: configuration.$isOn) { configuration.label }.toggleStyle(.switch) }
    }
}
#Preview { Toggle("Chicken", isOn: .constant(true)).toggleStyle(CheckToggleStyle()) }
