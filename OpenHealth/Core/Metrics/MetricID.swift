enum MetricID: String, Codable, CaseIterable, Sendable {
    case steps
    case distance
    case activeEnergy
    case totalEnergy
    case exerciseMinutes
    case heartRate
    case restingHR
    case hrv
    case recovery
    case weight
    case hydration
    case sleep
    case stress
    case caloriesIn
    case protein
    case carbs
    case fat
}
