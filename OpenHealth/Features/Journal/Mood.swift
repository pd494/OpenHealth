enum Mood: Int, CaseIterable, Identifiable {
    case rough = 1
    case low
    case okay
    case good
    case great

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .rough: "Rough"
        case .low: "Low"
        case .okay: "Okay"
        case .good: "Good"
        case .great: "Great"
        }
    }

    var symbol: String {
        switch self {
        case .rough: "cloud.bolt.rain.fill"
        case .low: "cloud.rain.fill"
        case .okay: "cloud.sun.fill"
        case .good: "sun.max.fill"
        case .great: "sparkles"
        }
    }
}
