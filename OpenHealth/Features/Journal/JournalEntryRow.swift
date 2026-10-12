import SwiftUI

struct JournalEntryRow: View {
    let entry: JournalEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !entry.text.isEmpty {
                Text(entry.text).font(.subheadline).lineLimit(3)
            }
            HStack(spacing: 6) {
                Label {
                    Text(entry.moodValue.title)
                } icon: {
                    Image(systemName: entry.moodValue.symbol).foregroundStyle(Palette.mind)
                }
                Text("·").accessibilityHidden(true)
                Text(entry.date, format: .dateTime.hour().minute())
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            if !entry.tags.isEmpty {
                HStack(spacing: 6) {
                    ForEach(entry.tags) { TagChip(tag: $0) }
                }
            }
        }
        .card()
        .accessibilityElement(children: .combine)
    }
}
