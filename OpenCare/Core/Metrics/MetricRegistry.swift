enum MetricRegistry {
    static func descriptor(_ id: MetricID) -> MetricDescriptor {
        switch id {
        case .steps: make(id, "Steps", "figure.walk", .activity, .count, goal: 10_000)
        case .distance: make(id, "Distance", "location.fill", .activity, .distance, goal: 5)
        case .activeEnergy: make(id, "Cal burned", "flame.fill", .activity, .energy, goal: 600)
        case .totalEnergy: make(id, "Cal burned", "flame.fill", .activity, .energy, goal: 2_400)
        case .exerciseMinutes: make(id, "Exercise", "timer", .activity, .minutes, goal: 30)
        case .heartRate: make(id, "Heart rate", "heart.fill", .heart, .bpm)
        case .restingHR: make(id, "Resting HR", "heart.text.square.fill", .heart, .bpm)
        case .hrv: make(id, "HRV", "waveform.path.ecg", .heart, .milliseconds)
        case .recovery: make(id, "Recovery", "bolt.heart.fill", .heart, .percent, goal: 100)
        case .weight: make(id, "Weight", "scalemass.fill", .body, .mass)
        case .hydration: make(id, "Hydration", "drop.fill", .hydration, .volume, goal: 80)
        case .sleep: make(id, "Sleep", "moon.stars.fill", .sleep, .duration, goal: 8)
        case .stress: make(id, "Stress", "brain.head.profile", .mind, .score)
        case .caloriesIn: make(id, "Cal in", "fork.knife", .nutrition, .energy, goal: 2_000)
        case .protein: make(id, "Protein", "p.circle.fill", .nutrition, .grams, goal: 120)
        case .carbs: make(id, "Carbs", "c.circle.fill", .nutrition, .grams, goal: 220)
        case .fat: make(id, "Fat", "f.circle.fill", .nutrition, .grams, goal: 70)
        }
    }

    private static func make(
        _ id: MetricID, _ title: String, _ symbol: String,
        _ domain: MetricDomain, _ format: MetricFormat, goal: Double? = nil
    ) -> MetricDescriptor {
        MetricDescriptor(id: id, title: title, symbol: symbol, domain: domain, format: format, defaultGoal: goal)
    }
}

extension MetricID {
    var descriptor: MetricDescriptor { MetricRegistry.descriptor(self) }
}
