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
                case oxygenSaturation = "averagePercentage"
                case respiratoryRate = "breathsPerMinute"
                case skinTemperature = "nightlyTemperatureCelsius"
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                date = try container.decode(CivilDate.self, forKey: .date)
                value = try container.decodeIfPresent(FlexibleDouble.self, forKey: .heartRateVariability)
                    ?? container.decodeIfPresent(FlexibleDouble.self, forKey: .restingHeartRate)
                    ?? container.decodeIfPresent(FlexibleDouble.self, forKey: .oxygenSaturation)
                    ?? container.decodeIfPresent(FlexibleDouble.self, forKey: .respiratoryRate)
                    ?? container.decodeIfPresent(FlexibleDouble.self, forKey: .skinTemperature)
            }
        }

        let dailyHeartRateVariability: Payload?
        let dailyRestingHeartRate: Payload?
        let dailyOxygenSaturation: Payload?
        let dailyRespiratoryRate: Payload?
        let dailySleepTemperatureDerivations: Payload?
    }

    let dataPoints: [Point]?

    /// Newest first.
    func metrics(for kind: DailyMetricKind) -> [DailyMetric] {
        (dataPoints ?? []).compactMap { point -> DailyMetric? in
            let payload: Point.Payload?
            switch kind {
            case .heartRateVariability: payload = point.dailyHeartRateVariability
            case .restingHeartRate: payload = point.dailyRestingHeartRate
            case .oxygenSaturation: payload = point.dailyOxygenSaturation
            case .respiratoryRate: payload = point.dailyRespiratoryRate
            case .skinTemperature: payload = point.dailySleepTemperatureDerivations
            }
            guard let date = payload?.date.startOfDay, let value = payload?.value?.value else { return nil }
            return DailyMetric(date: date, value: value)
        }.sorted { $0.date > $1.date }
    }
}
