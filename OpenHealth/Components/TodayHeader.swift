import SwiftUI

struct TodayHeader: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.presentLog) private var presentLog
    @Binding var isEditing: Bool
    let openSettings: () -> Void

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
            Button("Log") { presentLog(.menu) }
                .font(.subheadline.weight(.semibold))
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .controlSize(.small)
            Button("Settings", systemImage: "person.crop.circle") { openSettings() }
                .labelStyle(.iconOnly)
                .font(.title3)
                .frame(minWidth: Layout.minTapTarget, minHeight: Layout.minTapTarget)
        }
        .padding(.vertical, -8)
    }
}

#Preview {
    TodayHeader(isEditing: .constant(false)) {}
        .padding()
}
