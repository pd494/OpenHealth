import Foundation

enum ActivityHistory {
    static let levels = [
        0, 1, 0, 2, 0, 1, 0,
        1, 2, 0, 1, 1, 0, 0,
        2, 1, 0, 3, 1, 0, 1,
        0, 1, 2, 1, 0, 1, 0,
        1, 0,
    ]
    static let calendar = Calendar.current
    static let end = calendar.startOfDay(for: .now)
    static let start = calendar.date(byAdding: .day, value: 1 - levels.count, to: end)!
    static let leadingDays = (calendar.component(.weekday, from: start) - calendar.firstWeekday + 7) % 7
    static let activeDays = levels.reduce(0) { $0 + ($1 > 0 ? 1 : 0) }
    static let totalMinutes = levels.reduce(0) { $0 + $1 * 45 }
    static let cumulativeMinutes: [Int] = {
        var total = 0
        return levels.map { level in
            total += level * 45
            return total
        }
    }()
}
