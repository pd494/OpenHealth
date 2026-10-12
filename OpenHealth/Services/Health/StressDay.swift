import Foundation

struct StressDay: Equatable {
    var points: [StressPoint]
    var interval: TimeInterval
    var sleepWindow: ClosedRange<Date>?
    var week: [DayValue]

    var current: StressPoint? { points.last }

    var average: Double? {
        guard !points.isEmpty else { return nil }
        return points.reduce(0) { $0 + $1.score } / Double(points.count)
    }

    var totalDuration: TimeInterval { interval * Double(points.count) }

    func duration(of band: StressBand) -> TimeInterval {
        interval * Double(points.filter { $0.band == band }.count)
    }

    func share(of band: StressBand) -> Double {
        points.isEmpty ? 0 : duration(of: band) / totalDuration
    }
}
