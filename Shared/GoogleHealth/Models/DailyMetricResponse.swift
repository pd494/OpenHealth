import Foundation

struct DailyMetricResponse: Decodable {
    struct Point: Decodable {
        struct Payload: Decodable {
            let date: CivilDate
            let value: FlexibleDouble?

            enum CodingKeys: String, CodingKey {
                case date
                case heartRateVariability = "averageHeartRateVariabilityMilliseconds"
                case restingHeartRate = "beatsPerMinute"
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                date = try container.decode(CivilDate.self, forKey: .date)
                value = try container.decodeIfPresent(FlexibleDouble.self, forKey: .heartRateVariability)
                    ?? container.decodeIfPresent(FlexibleDouble.self, forKey: .restingHeartRate)
            }
        }

        let dailyHeartRateVariability: Payload?
        let dailyRestingHeartRate: Payload?
    }

    let dataPoints: [Point]?

    /// Newest first.
    func metrics(for kind: DailyMetricKind) -> [DailyMetric] {
        (dataPoints ?? []).compactMap { point -> DailyMetric? in
            let payload = kind == .heartRateVariability ? point.dailyHeartRateVariability : point.dailyRestingHeartRate
            guard let date = payload?.date.startOfDay, let value = payload?.value?.value else { return nil }
            return DailyMetric(date: date, value: value)
        }.sorted { $0.date > $1.date }
    }
}
