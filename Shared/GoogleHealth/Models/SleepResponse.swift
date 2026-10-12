import Foundation

struct SleepResponse: Decodable {
    struct Point: Decodable {
        struct Sleep: Decodable {
            struct Interval: Decodable {
                let endTime: Date
            }

            struct Summary: Decodable {
                let minutesAsleep: FlexibleDouble?
            }

            let interval: Interval?
            let summary: Summary?
        }

        let sleep: Sleep?
    }

    let dataPoints: [Point]?

    /// Hours in the newest session, preferring sessions of 3+ hours so a later nap doesn't replace the night.
    var lastNightHours: Double? {
        let sessions = (dataPoints ?? []).compactMap { point -> (end: Date, minutes: Double)? in
            guard let sleep = point.sleep,
                  let end = sleep.interval?.endTime,
                  let minutes = sleep.summary?.minutesAsleep?.value else { return nil }
            return (end, minutes)
        }
        let mainSessions = sessions.filter { $0.minutes >= 180 }
        return (mainSessions.isEmpty ? sessions : mainSessions)
            .max { $0.end < $1.end }
            .map { $0.minutes / 60 }
    }
}
