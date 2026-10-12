import SwiftUI

struct JournalEntryRow: View {
    let entry: JournalEntry

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: entry.moodValue.symbol)
                .foregroundStyle(Palette.mind)
                .frame(width: 38, height: 38)
                .background(Palette.mind.opacity(0.14), in: .circle)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(entry.moodValue.title).font(.subheadline.weight(.semibold))
                    Spacer()
                    Text(entry.date, format: .dateTime.hour().minute()).font(.caption).foregroundStyle(.secondary)
                }
                if !entry.text.isEmpty {
                    Text(entry.text).font(.subheadline).foregroundStyle(.secondary).lineLimit(3)
                }
                if !entry.tags.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(entry.tags) { TagChip(tag: $0) }
                    }
                }
            }
        }
        .card()
        .accessibilityElement(children: .combine)
    }
}
