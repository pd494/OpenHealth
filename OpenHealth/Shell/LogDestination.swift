/// Everything the log sheet can open to. `menu` is the list that picks between the others.
enum LogDestination: String, Hashable, Identifiable {
    case menu
    case food
    case activity
    case water
    case weight

    var id: Self { self }

    var title: String {
        switch self {
        case .menu: "Log"
        case .food: "Log food"
        case .activity: "Log activity"
        case .water: "Log water"
        case .weight: "Log weight"
        }
    }

    var symbol: String {
        switch self {
        case .menu: "square.and.pencil"
        case .food: "fork.knife"
        case .activity: "figure.run"
        case .water: "drop.fill"
        case .weight: "scalemass.fill"
        }
    }

    init?(debugName: String) { self.init(rawValue: debugName.lowercased()) }
}
