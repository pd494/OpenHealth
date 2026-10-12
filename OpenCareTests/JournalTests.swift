import SwiftData
import XCTest
@testable import OpenCare

@MainActor
final class JournalTests: XCTestCase {
    func testEntriesPersistTagsAndMood() throws {
        let store = JournalStore(inMemory: true)
        let context = store.container.mainContext
        context.insert(JournalEntry(text: "Late coffee", mood: Mood.low.rawValue, tags: [.caffeine, .lateMeal]))
        try context.save()
        let fetched = try context.fetch(FetchDescriptor<JournalEntry>())
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.tags, [.caffeine, .lateMeal])
        XCTAssertEqual(fetched.first?.moodValue, .low)
    }

    func testGroupingBucketsByDayNewestFirst() {
        let today = Calendar.current.startOfDay(for: .now)
        let entries = [
            JournalEntry(date: today.adding(9, .hour), text: "morning"),
            JournalEntry(date: today.adding(20, .hour), text: "evening"),
            JournalEntry(date: today.adding(-1, .day).adding(8, .hour), text: "yesterday")
        ]
        let days = JournalDay.grouping(entries)
        XCTAssertEqual(days.map(\.day), [today, today.adding(-1, .day)])
        XCTAssertEqual(days.first?.entries.map(\.text), ["evening", "morning"])
    }

    func testSeedingOnlyRunsOnAnEmptyStore() throws {
        let store = JournalStore(inMemory: true)
        store.seedDemoEntries()
        let count = try store.container.mainContext.fetchCount(FetchDescriptor<JournalEntry>())
        XCTAssertGreaterThan(count, 0)
        store.seedDemoEntries()
        XCTAssertEqual(try store.container.mainContext.fetchCount(FetchDescriptor<JournalEntry>()), count)
    }

    func testUnknownMoodFallsBackToOkay() {
        XCTAssertEqual(JournalEntry(mood: 9).moodValue, .okay)
    }
}
