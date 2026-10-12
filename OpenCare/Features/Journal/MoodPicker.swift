import SwiftUI

struct MoodPicker: View {
    @Binding var mood: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(Mood.allCases) { option in
                Button { mood = option.rawValue } label: {
                    VStack(spacing: 6) {
                        Image(systemName: option.symbol).font(.title3)
                        Text(option.title).font(.caption2)
                    }
                    .foregroundStyle(mood == option.rawValue ? Palette.mind : Color.secondary)
                    .frame(maxWidth: .infinity, minHeight: Layout.minTapTarget + 20)
                    .background(
                        mood == option.rawValue ? Palette.mind.opacity(0.16) : Color.white.opacity(0.05),
                        in: .rect(cornerRadius: 16)
                    )
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(mood == option.rawValue ? .isSelected : [])
            }
        }
        .sensoryFeedback(.selection, trigger: mood)
    }
}
