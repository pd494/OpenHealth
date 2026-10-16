/// One block on the Today calendar: something that happened, or was logged, during the day.
struct DayEntry: Identifiable {
    enum Kind {
        case sleep
        case meal
        case activity
        case water

        var domain: MetricDomain {
            switch self {
            case .sleep: .sleep
            case .meal: .nutrition
            case .activity: .activity
            case .water: .hydration
            }
        }

        var symbol: String {
            switch self {
            case .sleep: "moon.fill"
            case .meal: "fork.knife"
            case .activity: "figure.run"
            case .water: "drop.fill"
            }
        }
    }

    let id: Int
    let kind: Kind
    let title: String
    let detail: String
    /// Minutes after midnight.
    let startMinute: Int
    let minutes: Int
    let source: DataSource
}

extension DayEntry {
    static let sampleNow = 14 * 60 + 20

    static let today: [DayEntry] = [
        DayEntry(id: 0, kind: .sleep, title: "Woke up", detail: "7h 12m · score 86", startMinute: 6 * 60, minutes: 78, source: .googleHealth),
        DayEntry(id: 1, kind: .meal, title: "Breakfast", detail: "Greek yogurt, granola · 520 kcal", startMinute: 8 * 60 + 10, minutes: 40, source: .manual),
        DayEntry(id: 2, kind: .activity, title: "Walk", detail: "32 min · 3,100 steps", startMinute: 9 * 60 + 20, minutes: 52, source: .googleHealth),
        DayEntry(id: 3, kind: .water, title: "Water", detail: "16 oz", startMinute: 10 * 60 + 30, minutes: 30, source: .manual),
        DayEntry(id: 4, kind: .meal, title: "Lunch", detail: "Chicken bowl · 640 kcal", startMinute: 12 * 60 + 30, minutes: 50, source: .manual),
        DayEntry(id: 5, kind: .meal, title: "Snack", detail: "Apple, almonds · 210 kcal", startMinute: 15 * 60, minutes: 35, source: .manual),
        DayEntry(id: 6, kind: .activity, title: "Strength training", detail: "55 min · 310 kcal", startMinute: 17 * 60 + 45, minutes: 65, source: .googleHealth),
    ]
}
