enum JournalTag: String, Codable, CaseIterable, Identifiable {
    case caffeine
    case alcohol
    case lateMeal
    case workout
    case travel
    case illness

    var id: String { rawValue }

    var title: String {
        switch self {
        case .caffeine: "Caffeine"
        case .alcohol: "Alcohol"
        case .lateMeal: "Late meal"
        case .workout: "Workout"
        case .travel: "Travel"
        case .illness: "Under the weather"
        }
    }

    var symbol: String {
        switch self {
        case .caffeine: "cup.and.saucer.fill"
        case .alcohol: "wineglass.fill"
        case .lateMeal: "fork.knife"
        case .workout: "figure.run"
        case .travel: "airplane"
        case .illness: "thermometer.medium"
        }
    }
}
