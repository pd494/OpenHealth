import Foundation

/// Turns raw heart-rate and HRV samples into a stress timeline.
enum StressSampler {
    private static let hrvCarryForward: TimeInterval = 12 * 3600

    /// HRV is sampled far less often than heart rate, so the latest reading is carried forward.
    static func points(
        heartRate: [DayValue],
        hrv: [DayValue],
        hrvBaseline: Double,
        restingHR: Double
    ) -> [StressPoint] {
        guard hrvBaseline > 0, restingHR > 0 else { return [] }
        let hrv = hrv.filter { $0.value > 0 }.sorted { $0.date < $1.date }
        return heartRate.filter { $0.value > 0 }.sorted { $0.date < $1.date }.compactMap { sample in
            guard let reading = hrv.last(where: { $0.date <= sample.date }),
                  sample.date.timeIntervalSince(reading.date) <= hrvCarryForward else { return nil }
            let score = StressScore.score(
                hrv: reading.value, hrvBaseline: hrvBaseline,
                heartRate: sample.value, restingHR: restingHR
            )
            return StressPoint(date: sample.date, score: score)
        }
    }

    static func dailyAverages(_ points: [StressPoint]) -> [DayValue] {
        Dictionary(grouping: points) { Calendar.current.startOfDay(for: $0.date) }
            .map { DayValue(date: $0.key, value: $0.value.reduce(0) { $0 + $1.score } / Double($0.value.count)) }
            .sorted { $0.date < $1.date }
    }
}
