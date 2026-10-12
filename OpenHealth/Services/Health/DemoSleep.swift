import Foundation

enum DemoSleep {
    private static let pattern: [(SleepStage, Int)] = [
        (.awake, 6), (.core, 34), (.deep, 52), (.core, 28), (.rem, 16), (.core, 40), (.deep, 36), (.core, 32),
        (.rem, 26), (.awake, 4), (.core, 38), (.rem, 34), (.core, 28), (.awake, 5), (.core, 30), (.rem, 24),
        (.core, 14)
    ]

    static func night(now: Date = .now) -> SleepNight {
        var cursor = Calendar.current.startOfDay(for: now).adding(-48, .minute)
        let segments = pattern.map { stage, minutes in
            defer { cursor = cursor.adding(minutes, .minute) }
            return SleepSegment(stage: stage, start: cursor, end: cursor.adding(minutes, .minute))
        }
        return SleepNight(segments: segments)
    }
}
