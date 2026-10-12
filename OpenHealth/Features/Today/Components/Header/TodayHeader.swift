import SwiftUI

struct TodayHeader: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Binding var sheet: TodaySheet?
    @Binding var isEditing: Bool

    var body: some View {
        HStack(spacing: 12) {
            Text(Date.now, format: .dateTime.weekday(.wide).month(.abbreviated).day())
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer(minLength: 8)
            Button(isEditing ? "Done" : "Edit") {
                withMotion(reduceMotion: reduceMotion) { isEditing.toggle() }
            }
            .font(.subheadline.weight(.semibold))
            .frame(minWidth: Layout.minTapTarget, minHeight: Layout.minTapTarget)
            .sensoryFeedback(.selection, trigger: isEditing)
            TodaySettingsMenu(sheet: $sheet)
        }
        .padding(.vertical, -8)
    }
}
