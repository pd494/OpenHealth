import SwiftData
import SwiftUI

struct JournalView: View {
    @Environment(\.modelContext) private var context
    @Environment(HealthManager.self) private var health
    @Environment(JournalStore.self) private var store
    @Query(sort: \JournalEntry.date, order: .reverse) private var entries: [JournalEntry]
    @State private var sheet: JournalSheet? = DebugLaunch.string("sheet") == "journalAdd" ? .new : nil

    var body: some View {
        List {
            header
            if entries.isEmpty {
                EmptyState(
                    title: "No entries yet",
                    message: "Note how you feel and what you did. Patterns show up over time.",
                    systemImage: "book.closed"
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            ForEach(JournalDay.grouping(entries)) { day in
                Section {
                    ForEach(day.entries) { entry in
                        Button { sheet = .edit(entry) } label: { JournalEntryRow(entry: entry) }
                            .buttonStyle(.pressable)
                            .listRowInsets(.init(top: 5, leading: Layout.screenPadding, bottom: 5, trailing: Layout.screenPadding))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .swipeActions { Button("Delete", systemImage: "trash", role: .destructive) { context.delete(entry) } }
                    }
                } header: {
                    Text(day.day, format: .dateTime.weekday(.wide).month().day()).eyebrow()
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Palette.background)
        .sheet(item: $sheet) { destination in
            switch destination {
            case .new: JournalEntryEditor(entry: nil)
            case .edit(let entry): JournalEntryEditor(entry: entry)
            }
        }
        .task { if health.isDemo { store.seedDemoEntries() } }
    }

    private var header: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Your notes").font(.subheadline).foregroundStyle(.secondary)
                Text("Journal").font(.rounded(.largeTitle, weight: .bold)).tracking(-0.8)
            }
            Spacer()
            Button("New entry", systemImage: "plus") { sheet = .new }
                .labelStyle(.iconOnly)
                .font(.title3.weight(.semibold))
                .frame(width: Layout.minTapTarget, height: Layout.minTapTarget)
                .background(Palette.green, in: .circle)
                .foregroundStyle(Palette.background)
        }
        .listRowInsets(.init(top: 12, leading: Layout.screenPadding, bottom: 12, trailing: Layout.screenPadding))
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}
