import Foundation

enum DemoStress {
    private static let interval: TimeInterval = 900

    static func day(now: Date = .now) -> StressDay {
        let end = Date(timeIntervalSince1970: (now.timeIntervalSince1970 / interval).rounded(.down) * interval)
        let start = end.addingTimeInterval(-24 * 3600)
        let midnight = Calendar.current.startOfDay(for: now)
        let sleepWindow = midnight.adding(-50, .minute)...midnight.adding(6 * 60 + 50, .minute)
        let points = (0..<96).map { index in
            let date = start.addingTimeInterval(Double(index) * interval)
            return StressPoint(date: date, score: score(at: date, asleep: sleepWindow.contains(date)))
        }
        let today = points.reduce(0) { $0 + $1.score } / Double(points.count)
        let history: [Double] = [33, 28, 41, 36, 30, 38]
        let week = (history + [today]).enumerated().map { index, value in
            DayValue(date: midnight.adding(index - 6, .day), value: value)
        }
        return StressDay(points: points, interval: interval, sleepWindow: sleepWindow, week: week)
    }

    private static func score(at date: Date, asleep: Bool) -> Double {
        let hour = date.timeIntervalSince(Calendar.current.startOfDay(for: date)) / 3600
        let wobble = 5 * sin(hour * 7.3) + 3 * sin(hour * 13.1)
        if asleep { return 13 + wobble }
        let bumps = 38 * bump(hour, 10.5, 1.4) + 50 * bump(hour, 15.5, 1.6) + 16 * bump(hour, 19, 1)
        return min(max(24 + bumps + wobble, 5), 95)
    }

    private static func bump(_ hour: Double, _ center: Double, _ width: Double) -> Double {
        exp(-pow((hour - center) / width, 2))
    }
}
