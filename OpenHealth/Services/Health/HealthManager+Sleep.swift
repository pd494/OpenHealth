import Foundation

extension HealthManager {
    func refreshSleepDetails() async {
        let now = Date.now
        let noon = Calendar.current.startOfDay(for: now).adding(-12, .hour)
        let segments = await reader.sleepSegments(from: noon, to: now)
        sleepNight = segments.isEmpty ? nil : SleepNight(segments: segments)
    }
}
