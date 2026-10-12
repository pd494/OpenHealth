import SwiftUI

struct TodayHeader: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Binding var sheet: TodaySheet?
    @Binding var isEditing: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Spacer()
                Button(isEditing ? "Done" : "Edit") { withMotion(reduceMotion: reduceMotion) { isEditing.toggle() } }
                    .font(.rounded(.subheadline, weight: .semibold))
                    .contentTransition(.opacity)
                    .frame(minHeight: Layout.minTapTarget)
                    .sensoryFeedback(.selection, trigger: isEditing)
                TodaySettingsMenu(sheet: $sheet)
            }
            Text(Date.now, format: .dateTime.weekday(.wide).month(.abbreviated).day())
                .font(.rounded(.largeTitle, weight: .bold))
                .tracking(-0.8)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            Text(greeting)
                .font(.subheadline)
                .foregroundStyle(.secondary)
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
