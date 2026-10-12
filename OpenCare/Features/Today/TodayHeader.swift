import SwiftUI

struct TodayHeader: View {
    @Binding var sheet: TodaySheet?
    @Binding var isEditing: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "circle.hexagongrid.fill")
                        .foregroundStyle(Palette.green)
                        .accessibilityHidden(true)
                    Text("OPENCARE")
                        .tracking(2.4)
                        .font(.rounded(.footnote, weight: .bold))
                }
                Spacer()
                Button(isEditing ? "Done" : "Edit") { withAnimation(.snappy) { isEditing.toggle() } }
                    .font(.rounded(.subheadline, weight: .semibold))
                    .padding(.horizontal, 14)
                    .frame(minHeight: Layout.minTapTarget)
                    .background(isEditing ? Palette.green.opacity(0.18) : Palette.card, in: .capsule)
                    .sensoryFeedback(.selection, trigger: isEditing)
                TodaySettingsMenu()
                Button("Edit goals", systemImage: "slider.horizontal.3") { sheet = .goals }
                    .iconOnlyButton()
                    .font(.title3)
                    .background(Palette.card, in: .circle)
            }
            Text("Today, in motion.")
                .font(.rounded(.title))
            Text(Date.now, format: .dateTime.weekday(.wide).month(.wide).day())
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}
