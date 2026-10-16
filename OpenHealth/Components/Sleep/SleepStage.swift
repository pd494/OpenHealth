import SwiftUI

/// Top to bottom is the order the lanes sit on the timeline.
enum SleepStage: CaseIterable {
    case awake
    case rem
    case core
    case deep

    var title: String {
        switch self {
        case .awake: "Awake"
        case .rem: "REM"
        case .core: "Core"
        case .deep: "Deep"
        }
    }

    /// The block colour on the timeline and the legend swatch.
    var fill: Color {
        switch self {
        case .awake: Color(red: 1, green: 0.624, blue: 0.263)
        case .rem: MetricDomain.sleep.ringEnd
        case .core: MetricDomain.sleep.ringStart
        case .deep: Color(red: 0.239, green: 0.165, blue: 0.541)
        }
    }

    /// The tile's number colour. Deep's dark violet would vanish on a dark card, so it lightens there.
    func text(in scheme: ColorScheme) -> Color {
        switch self {
        case .awake: fill
        case .rem: Color(red: 0.604, green: 0.514, blue: 0.878)
        case .core: Color(red: 0.451, green: 0.341, blue: 0.82)
        case .deep: scheme == .dark ? Color(red: 0.7, green: 0.64, blue: 0.94) : Color(red: 0.18, green: 0.122, blue: 0.451)
        }
    }

    /// A typical share of time asleep, for the Benchmarks tab. Awake time isn't part of the sleep total.
    var typicalShare: ClosedRange<Double>? {
        switch self {
        case .awake: nil
        case .rem: 0.20...0.25
        case .core: 0.45...0.55
        case .deep: 0.13...0.23
        }
    }
}
