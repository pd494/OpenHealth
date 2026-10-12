enum AppTab: String, CaseIterable, Identifiable {
    case today
    case sleep
    case fitness
    case journal

    var id: String { rawValue }

    var title: String {
        switch self {
        case .today: "Today"
        case .sleep: "Sleep"
        case .fitness: "Fitness"
        case .journal: "Journal"
        }
    }

    var symbol: String {
        switch self {
        case .today: "circle.hexagongrid.fill"
        case .sleep: "moon.stars.fill"
        case .fitness: "figure.run"
        case .journal: "book.closed.fill"
        }
    }
}
