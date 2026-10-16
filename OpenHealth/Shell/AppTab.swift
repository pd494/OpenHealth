enum AppTab: String, CaseIterable {
    case today
    case nutrition
    case sleep
    case fitness

    var title: String { rawValue.capitalized }

    var symbol: String {
        switch self {
        case .today: "sun.max"
        case .nutrition: "fork.knife"
        case .sleep: "moon.zzz"
        case .fitness: "figure.run"
        }
    }

    init?(debugName: String) { self.init(rawValue: debugName.lowercased()) }
}
