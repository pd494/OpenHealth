/// The activity types offered when logging a workout. The names follow Google Health's exercise list.
enum ActivityKind: CaseIterable {
    case walk
    case run
    case cycle
    case swim
    case strength
    case hiit
    case yoga
    case hike
    case pilates
    case row

    var title: String {
        switch self {
        case .walk: "Walk"
        case .run: "Run"
        case .cycle: "Cycle"
        case .swim: "Swim"
        case .strength: "Strength"
        case .hiit: "HIIT"
        case .yoga: "Yoga"
        case .hike: "Hike"
        case .pilates: "Pilates"
        case .row: "Row"
        }
    }

    var symbol: String {
        switch self {
        case .walk: "figure.walk"
        case .run: "figure.run"
        case .cycle: "figure.outdoor.cycle"
        case .swim: "figure.pool.swim"
        case .strength: "figure.strengthtraining.traditional"
        case .hiit: "figure.highintensity.intervaltraining"
        case .yoga: "figure.yoga"
        case .hike: "figure.hiking"
        case .pilates: "figure.pilates"
        case .row: "figure.rower"
        }
    }
}
