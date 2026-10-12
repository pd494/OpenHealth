import Foundation

struct StressPoint: Identifiable, Equatable {
    let date: Date
    let score: Double

    var id: Date { date }
    var band: StressBand { StressScore.band(score) }
}
