import Foundation

struct Workout: Identifiable {
    let id: Int
    let kind: ActivityKind
    let start: Date
    let minutes: Int
    let kcal: Int
    let source: DataSource
}

extension Workout {
    static let recent: [Workout] = [
        Workout(id: 0, kind: .strength, start: .daysAgo(0, minute: 17 * 60 + 45), minutes: 55, kcal: 310, source: .googleHealth),
        Workout(id: 1, kind: .walk, start: .daysAgo(0, minute: 9 * 60 + 20), minutes: 32, kcal: 140, source: .googleHealth),
        Workout(id: 2, kind: .yoga, start: .daysAgo(1, minute: 7 * 60), minutes: 40, kcal: 120, source: .manual),
        Workout(id: 3, kind: .run, start: .daysAgo(3, minute: 18 * 60 + 10), minutes: 28, kcal: 280, source: .googleHealth),
    ]
}

private extension Date {
    static func daysAgo(_ days: Int, minute: Int) -> Date {
        let calendar = Calendar.current
        let day = calendar.date(byAdding: .day, value: -days, to: calendar.startOfDay(for: .now))!
        return calendar.date(byAdding: .minute, value: minute, to: day)!
    }
}
