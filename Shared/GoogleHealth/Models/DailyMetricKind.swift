enum DailyMetricKind {
    case heartRateVariability
    case restingHeartRate
    case oxygenSaturation, respiratoryRate, skinTemperature

    var dataType: String {
        switch self {
        case .heartRateVariability: "daily-heart-rate-variability"
        case .restingHeartRate: "daily-resting-heart-rate"
        case .oxygenSaturation: "daily-oxygen-saturation"
        case .respiratoryRate: "daily-respiratory-rate"
        case .skinTemperature: "daily-sleep-temperature-derivations"
        }
    }

    var filterKey: String { dataType.replacing("-", with: "_") }
}
