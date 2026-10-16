struct SleepSegment: Identifiable {
    let id: Int
    let stage: SleepStage
    /// Minutes after getting into bed.
    let start: Int
    let minutes: Int

    var end: Int { start + minutes }
}
