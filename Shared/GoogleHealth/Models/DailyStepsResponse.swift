import Foundation

struct DailyStepsResponse: Decodable {
    struct Point: Decodable {
        struct CivilStart: Decodable {
            let date: CivilDate
        }

        struct Steps: Decodable {
            let countSum: FlexibleDouble?
        }

        let civilStartTime: CivilStart?
        let steps: Steps?
    }

    // Google omits empty arrays and days without data.
    let rollupDataPoints: [Point]?

    /// Newest first.
    var days: [DailyStepCount] {
        (rollupDataPoints ?? []).compactMap { point in
            guard let date = point.civilStartTime?.date.startOfDay,
                  let count = point.steps?.countSum?.value else { return nil }
            return DailyStepCount(date: date, count: Int(count))
        }.sorted { $0.date > $1.date }
    }
}
