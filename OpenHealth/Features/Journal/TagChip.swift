import SwiftUI

struct TagChip: View {
    let tag: JournalTag
    var isSelected = true

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: tag.symbol).accessibilityHidden(true)
            Text(tag.title)
        }
            .font(.caption.weight(.medium))
            .fixedSize()
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .foregroundStyle(isSelected ? Color.primary : Color.secondary)
            .background(isSelected ? Palette.mind.opacity(0.22) : Color.white.opacity(0.06), in: .capsule)
            .overlay { Capsule().strokeBorder(isSelected ? Palette.mind.opacity(0.5) : Palette.hairline) }
    }
}
