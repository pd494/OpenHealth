import Foundation

struct SleepSegment: Identifiable, Equatable {
    let stage: SleepStage
    let start: Date
    let end: Date

    var id: Date { start }
    var duration: TimeInterval { end.timeIntervalSince(start) }
}
