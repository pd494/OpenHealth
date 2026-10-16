import SwiftUI

/// A segmented control in the sleep tint, with a raised white thumb that glides between segments.
struct SleepTabs: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Namespace private var thumb

    @Binding var selection: SleepTab

    private static let inset = 3.0

    var body: some View {
        HStack(spacing: 0) {
            ForEach(SleepTab.allCases, id: \.self) { tab in
                Button {
                    withMotion(reduceMotion: reduceMotion) { selection = tab }
                } label: {
                    Text(tab.rawValue)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(tab == selection ? MetricDomain.sleep.ringLabel : Color.secondary)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, minHeight: 32)
                        .background {
                            if tab == selection { thumbShape }
                        }
                        .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(tab == selection ? .isSelected : [])
            }
        }
        .padding(Self.inset)
        .background(Palette.sleepTray, in: .rect(cornerRadius: 14, style: .continuous))
        .sensoryFeedback(.selection, trigger: selection)
    }

    private var thumbShape: some View {
        RoundedRectangle(cornerRadius: 11, style: .continuous)
            .fill(colorScheme == .dark ? Color.white.opacity(0.14) : .white)
            .shadow(color: .black.opacity(0.1), radius: 3, y: 1.5)
            .matchedGeometryEffect(id: "thumb", in: thumb)
    }
}
