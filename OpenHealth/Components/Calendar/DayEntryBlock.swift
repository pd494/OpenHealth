import SwiftUI

struct DayEntryBlock: View {
    let entry: DayEntry
    let hourHeight: Double

    private var blockHeight: Double {
        max(Double(entry.minutes) / 60 * hourHeight - 4, 36)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: entry.kind.symbol)
                .font(.footnote)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 0) {
                Text(entry.title)
                    .font(.footnote.weight(.semibold))
                Text(entry.detail)
                    .font(.caption)
                if entry.minutes >= 60 {
                    Text(entry.source.title.uppercased())
                        .font(.caption2)
                        .opacity(0.7)
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .foregroundStyle(entry.kind.domain.adaptiveLabel)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity, minHeight: blockHeight, alignment: .topLeading)
        .background(entry.kind.domain.ringStart.opacity(0.16), in: .rect(cornerRadius: 12, style: .continuous))
        .background(Palette.card, in: .rect(cornerRadius: 12, style: .continuous))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(entry.title), \(entry.detail), \(entry.source.title)")
    }
}

#Preview {
    DayEntryBlock(entry: DayEntry.today[0], hourHeight: 56)
        .padding()
}
