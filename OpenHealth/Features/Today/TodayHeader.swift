import SwiftUI

struct TodayHeader: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Binding var sheet: TodaySheet?
    @Binding var isEditing: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            VStack(alignment: .leading, spacing: 0) {
                Text(greeting)
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(.secondary)
                Text(Date.now, format: .dateTime.weekday(.wide).month(.abbreviated).day())
                    .font(.rounded(.title2, weight: .bold))
                    .tracking(-0.4)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
                    .accessibilityAddTraits(.isHeader)
            }
            Spacer(minLength: 8)
            Button { withMotion(reduceMotion: reduceMotion) { isEditing.toggle() } } label: {
                Text(isEditing ? "Done" : "Edit")
                    .font(.rounded(.subheadline, weight: .semibold))
                    .contentTransition(.opacity)
                    .padding(.horizontal, 14)
                    .frame(height: 34)
                    .chrome(in: .capsule)
            }
            .frame(minHeight: Layout.minTapTarget)
            .sensoryFeedback(.selection, trigger: isEditing)
            TodaySettingsMenu(sheet: $sheet)
        }
    }

    private var greeting: String {
        switch Calendar.current.component(.hour, from: .now) {
        case 5..<12: "Good morning"
        case 12..<18: "Good afternoon"
        default: "Good evening"
        }
    }
}
