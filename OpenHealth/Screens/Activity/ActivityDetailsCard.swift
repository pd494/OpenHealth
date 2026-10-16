import SwiftUI

struct ActivityDetailsCard: View {
    @Binding var start: Date
    @Binding var minutes: Int
    @State private var distance: Double?

    private var duration: String {
        Duration.seconds(minutes * 60).formatted(.units(allowed: [.hours, .minutes], width: .narrow))
    }

    var body: some View {
        VStack(spacing: 12) {
            LabeledContent("Start") {
                DatePicker("Start", selection: $start, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.compact)
                    .labelsHidden()
            }
            Hairline(axis: .horizontal)
            LabeledContent("Duration") {
                VStack(alignment: .trailing, spacing: 8) {
                    Text(duration).monospacedDigit()
                    Stepper("Duration", value: $minutes, in: 5...300, step: 5)
                        .labelsHidden()
                        .accessibilityValue(duration)
                }
            }
            Hairline(axis: .horizontal)
            LabeledContent("Distance") {
                HStack(spacing: 8) {
                    TextField("Optional", value: $distance, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .accessibilityLabel("Distance in miles")
                    Text("mi").foregroundStyle(.secondary)
                }
                .frame(minHeight: Layout.minTapTarget)
            }
            Hairline(axis: .horizontal)
            LabeledContent("Active energy") {
                Text("~\(minutes * 6, format: .number) kcal (est.)")
                    .foregroundStyle(.secondary)
            }
            .accessibilityElement(children: .combine)
        }
        .font(.subheadline)
        .padding(Layout.cardPadding)
        .surface()
    }
}

#Preview { ActivityDetailsCard(start: .constant(.now), minutes: .constant(30)).padding() }
