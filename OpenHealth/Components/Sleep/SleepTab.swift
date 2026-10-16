enum SleepTab: String, CaseIterable {
    case timeline = "Timeline"
    case benchmarks = "Benchmarks"
    case week = "Week"

    init?(debugName: String) { self.init(rawValue: debugName.capitalized) }

    /// What sits under the card for tabs that have no scrub readout.
    var caption: String? {
        switch self {
        case .timeline: nil
        case .benchmarks: "Share of time asleep, against typical adult ranges"
        case .week: "Hours asleep over the last 7 nights"
        }
    }
}
