/// The single place a metric is defined. To add one, add a case to `MetricID` and a line below.
enum MetricRegistry {
    /// Built once; `id.descriptor` is read on every render.
    static let all: [MetricID: MetricDescriptor] = Dictionary(
        uniqueKeysWithValues: MetricID.allCases.map { ($0, build($0)) }
    )

    private static func build(_ id: MetricID) -> MetricDescriptor {
        switch id {
        case .steps: make(id, "Steps", "figure.walk", .activity, .count, goal: 10_000, value: 6_428)
        case .distance: make(id, "Distance", "location.fill", .activity, .distance, goal: 5, value: 3.1)
        case .activeEnergy: make(id, "Cal burned", "flame.fill", .activity, .energy, goal: 600, value: 412)
        case .exerciseMinutes: make(id, "Exercise", "timer", .activity, .minutes, goal: 30, value: 28)
        case .recovery: make(id, "Recovery", "bolt.heart.fill", .heart, .percent, goal: 100, value: 71)
        case .hydration: make(id, "Hydration", "drop.fill", .hydration, .volume, goal: 80, value: 44)
        case .sleep: make(id, "Sleep", "moon.stars.fill", .sleep, .duration, goal: 8, value: 7.2)
        case .caloriesIn: make(id, "Cal in", "fork.knife", .nutrition, .energy, goal: 2_000, value: 1_640)
        case .protein: make(id, "Protein", "p.circle.fill", .nutrition, .grams, goal: 120, value: 92)
        case .carbs: make(id, "Carbs", "c.circle.fill", .nutrition, .grams, goal: 220, value: 168)
        case .fat: make(id, "Fat", "f.circle.fill", .nutrition, .grams, goal: 70, value: 54)
        }
    }

    private static func make(
        _ id: MetricID, _ title: String, _ symbol: String, _ domain: MetricDomain, _ format: MetricFormat,
        goal: Double, value: Double
    ) -> MetricDescriptor {
        MetricDescriptor(id: id, title: title, symbol: symbol, domain: domain, format: format, goal: goal, value: value)
    }
}

extension MetricID {
    var descriptor: MetricDescriptor { MetricRegistry.all[self]! }
}
