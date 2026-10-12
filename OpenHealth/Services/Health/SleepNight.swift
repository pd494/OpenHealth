import Foundation

struct SleepNight: Equatable {
    var segments: [SleepSegment]

    var bedtime: Date? { segments.first?.start }
    var wakeTime: Date? { segments.last?.end }

    func duration(of stage: SleepStage) -> TimeInterval {
        segments.filter { $0.stage == stage }.reduce(0) { $0 + $1.duration }
    }

    var asleepHours: Double {
        SleepStage.allCases.filter { $0 != .awake }.reduce(0) { $0 + duration(of: $1) } / 3600
    }
}
