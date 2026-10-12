import SwiftUI

struct TodayHeader: View {
    @Binding var sheet: TodaySheet?
    @Binding var isEditing: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "circle.hexagongrid.fill")
                    .font(.footnote)
                    .foregroundStyle(Palette.green)
                    .accessibilityHidden(true)
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
