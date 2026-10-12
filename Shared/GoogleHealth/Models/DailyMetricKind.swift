enum DailyMetricKind {
    case heartRateVariability
    case restingHeartRate

    var dataType: String {
        switch self {
        case .heartRateVariability: "daily-heart-rate-variability"
        case .restingHeartRate: "daily-resting-heart-rate"
        }
    }

    var filterKey: String { dataType.replacing("-", with: "_") }
}
