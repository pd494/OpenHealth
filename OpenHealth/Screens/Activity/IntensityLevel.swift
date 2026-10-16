enum IntensityLevel: String {
    case easy = "Easy"
    case light = "Light"
    case moderate = "Moderate"
    case tiring = "Tiring"
    case allOut = "All out"

    init(intensity: Double) {
        switch intensity {
        case ...2: self = .easy
        case ...4: self = .light
        case ...6: self = .moderate
        case ...8: self = .tiring
        default: self = .allOut
        }
    }

    var description: String {
        switch self {
        case .easy: "Relaxed breathing, can talk comfortably"
        case .light: "Slightly deeper breathing, conversation is easy"
        case .moderate: "Breathing faster, can speak in sentences"
        case .tiring: "Heavy breathing, can speak in short phrases"
        case .allOut: "Maximum effort, can barely speak"
        }
    }
}
