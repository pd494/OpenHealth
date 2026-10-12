import Foundation
import SwiftData

@Model
final class JournalEntry {
    var date: Date
    var text: String
    var mood: Int
    var tags: [JournalTag]

    init(date: Date = .now, text: String = "", mood: Int = Mood.okay.rawValue, tags: [JournalTag] = []) {
        self.date = date
        self.text = text
        self.mood = mood
        self.tags = tags
    }

    var moodValue: Mood { Mood(rawValue: mood) ?? .okay }
}

struct JournalDay: Identifiable {
    let day: Date
    let entries: [JournalEntry]

    var id: Date { day }

    static func grouping(_ entries: [JournalEntry]) -> [JournalDay] {
        Dictionary(grouping: entries) { Calendar.current.startOfDay(for: $0.date) }
            .map { JournalDay(day: $0.key, entries: $0.value.sorted { $0.date > $1.date }) }
            .sorted { $0.day > $1.day }
    }
}
