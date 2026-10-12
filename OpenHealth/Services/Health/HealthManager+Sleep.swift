import Foundation

extension HealthManager {
    func refreshSleepDetails() async {
        let now = Date.now
        let noon = Calendar.current.startOfDay(for: now).adding(-12, .hour)
        let segments = await reader.sleepSegments(from: noon, to: now)
        sleepNight = segments.isEmpty ? nil : SleepNight(segments: segments)
        var week: [DayValue] = []
        for daysBack in (0..<7).reversed() {
            let end = noon.adding(12 - 24 * daysBack, .hour)
            let hours = await reader.sleepHours(from: end.adding(-24, .hour), to: min(end, now))
            week.append(DayValue(date: Calendar.current.startOfDay(for: end), value: hours))
        }
        sleepWeek = week
    }
}
