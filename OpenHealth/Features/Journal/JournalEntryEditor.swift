import SwiftData
import SwiftUI

struct JournalEntryEditor: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var date: Date
    @State private var text: String
    @State private var mood: Int
    @State private var tags: Set<JournalTag>
    @State private var saved = false

    let entry: JournalEntry?

    init(entry: JournalEntry?) {
        self.entry = entry
        _date = State(initialValue: entry?.date ?? .now)
        _text = State(initialValue: entry?.text ?? "")
        _mood = State(initialValue: entry?.mood ?? Mood.okay.rawValue)
        _tags = State(initialValue: Set(entry?.tags ?? []))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("How did it feel?").eyebrow()
                        MoodPicker(mood: $mood)
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Notes").eyebrow()
                        TextField("What stood out today?", text: $text, axis: .vertical)
                            .lineLimit(4...10)
                            .padding(14)
                            .inputSurface()
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Tags").eyebrow()
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 8)], alignment: .leading, spacing: 8) {
                            ForEach(JournalTag.allCases) { tag in
                                Button { toggle(tag) } label: { TagChip(tag: tag, isSelected: tags.contains(tag)) }
                                    .buttonStyle(.plain)
                            }
                        }
                        .sensoryFeedback(.selection, trigger: tags)
                    }
                    DatePicker("When", selection: $date)
                    if let entry {
                        Button("Delete entry", systemImage: "trash", role: .destructive) { delete(entry) }
                    }
                }
                .padding(Layout.sheetPadding)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Palette.background)
            .navigationTitle(entry == nil ? "New entry" : "Edit entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("Save", action: save) }
            }
            .sensoryFeedback(.success, trigger: saved)
        }
    }

    private func toggle(_ tag: JournalTag) {
        if !tags.insert(tag).inserted { tags.remove(tag) }
    }

    private func save() {
        let ordered = JournalTag.allCases.filter(tags.contains)
        if let entry {
            entry.date = date
            entry.text = text
            entry.mood = mood
            entry.tags = ordered
        } else {
            context.insert(JournalEntry(date: date, text: text, mood: mood, tags: ordered))
        }
        saved = true
        dismiss()
    }

    private func delete(_ entry: JournalEntry) {
        context.delete(entry)
        dismiss()
    }
}

#Preview {
    JournalEntryEditor(entry: nil)
        .modelContainer(for: JournalEntry.self, inMemory: true)
}
