import Foundation
import Observation
import SwiftData

@MainActor @Observable
final class JournalStore {
    let container: ModelContainer

    init(inMemory: Bool = false) {
        do {
            container = try ModelContainer(
                for: JournalEntry.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: inMemory)
            )
        } catch {
            fatalError("Journal store could not be created: \(error)")
        }
    }

    func seedDemoEntries() {
        let context = container.mainContext
        guard (try? context.fetchCount(FetchDescriptor<JournalEntry>())) == 0 else { return }
        let today = Calendar.current.startOfDay(for: .now)
        let samples: [(Int, Int, String, Mood, [JournalTag])] = [
            (0, 8 * 60 + 5, "Slept well, easy morning. Short walk before work.", .good, [.workout]),
            (-1, 21 * 60 + 40, "Late dinner after the run. Felt heavy going to bed.", .okay, [.lateMeal, .workout]),
            (-1, 14 * 60, "Third coffee. Focus was great, then a crash around 4.", .okay, [.caffeine]),
            (-2, 22 * 60 + 10, "Drinks with friends. Fun night, short on sleep.", .low, [.alcohol, .lateMeal]),
            (-4, 9 * 60, "Flight in the morning, tired all day.", .rough, [.travel, .caffeine]),
            (-5, 19 * 60, "Best day this week. Long ride and early night.", .great, [.workout])
        ]
        for (dayOffset, minutes, text, mood, tags) in samples {
            let date = today.adding(dayOffset, .day).adding(minutes, .minute)
            context.insert(JournalEntry(date: date, text: text, mood: mood.rawValue, tags: tags))
        }
    }
}
