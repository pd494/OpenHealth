import Foundation

struct DailyDashboardResponse: Decodable {
    struct Point: Decodable {
        struct Scalar: Decodable {
            let value: Double?

            enum CodingKeys: String, CodingKey, CaseIterable {
                case kcalSum, millimetersSum, countSum, beatsPerMinuteAvg, weightGramsAvg
                case bodyFatPercentageAvg, rateAvg, bloodGlucoseMilligramsPerDeciliterAvg
                case temperatureCelsiusAvg, gainMillimetersSum
                case sumInPeakHeartZone, sumInCardioHeartZone, sumInFatBurnHeartZone
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let fields = try CodingKeys.allCases.compactMap { key in
                    try container.decodeIfPresent(FlexibleDouble.self, forKey: key)?.value
                }
                value = fields.isEmpty ? nil : fields.reduce(0, +)
            }
        }

        struct Quantity: Decodable {
            let kcalSum: FlexibleDouble?
            let gramsSum: FlexibleDouble?
            let millilitersSum: FlexibleDouble?
        }

        struct Nutrition: Decodable {
            struct Nutrient: Decodable {
                let nutrient: String
                let quantity: Quantity
            }
            let energy: Quantity?
            let totalCarbohydrate: Quantity?
            let totalFat: Quantity?
            let nutrients: [Nutrient]?
        }

        struct ActiveMinutes: Decodable {
            struct Level: Decodable {
                let activityLevel: String
                let activeMinutesSum: FlexibleDouble?
            }
            let activeMinutesRollupByActivityLevel: [Level]?
        }

        struct Hydration: Decodable {
            let amountConsumed: Quantity?
        }

        let civilStartTime: DailyStepsResponse.Point.CivilStart?
        let activeEnergyBurned: Scalar?
        let totalCalories: Scalar?
        let distance: Scalar?
        let heartRate: Scalar?
        let weight: Scalar?
        let bodyFat: Scalar?
        let runVo2Max: Scalar?
        let bloodGlucose: Scalar?
        let coreBodyTemperature: Scalar?
        let altitude: Scalar?
        let floors: Scalar?
        let activeZoneMinutes: Scalar?
        let activeMinutes: ActiveMinutes?
        let nutritionLog: Nutrition?
        let hydrationLog: Hydration?

        var values: [String: Double] {
            let values: [String: Double?] = [
                "activeEnergy": activeEnergyBurned?.value,
                "totalEnergy": totalCalories?.value,
                "distance": distance?.value.map { $0 / 1_609_344 },
                "heartRate": heartRate?.value,
                "weight": weight?.value.map { $0 / 453.59237 },
                "bodyFat": bodyFat?.value,
                "vo2Max": runVo2Max?.value,
                "bloodGlucose": bloodGlucose?.value,
                "bodyTemperature": coreBodyTemperature?.value,
                "elevationGain": altitude?.value.map { $0 / 304.8 },
                "floors": floors?.value,
                "activeZoneMinutes": activeZoneMinutes?.value,
                "exerciseMinutes": activeMinutes?.activeMinutesRollupByActivityLevel.map { levels in
                    levels.filter { $0.activityLevel == "MODERATE" || $0.activityLevel == "VIGOROUS" }
                        .compactMap { $0.activeMinutesSum?.value }.reduce(0, +)
                },
                "caloriesIn": nutritionLog?.energy?.kcalSum?.value,
                "carbs": nutritionLog?.totalCarbohydrate?.gramsSum?.value,
                "fat": nutritionLog?.totalFat?.gramsSum?.value,
                "protein": nutritionLog?.nutrients?.first { $0.nutrient == "PROTEIN" }?.quantity.gramsSum?.value,
                "hydration": (hydrationLog?.amountConsumed?.millilitersSum?.value).map { $0 / 29.5735295625 }
            ]
            return values.compactMapValues { $0 }
        }
    }

    let rollupDataPoints: [Point]?
}
