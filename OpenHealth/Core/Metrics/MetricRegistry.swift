import HealthKit

/// The single place a Today metric is defined. To add one:
/// 1. Add a case to `MetricID`.
/// 2. Add a line below with its title, symbol, domain, format, goal, HealthKit query, subtitle, tap sheet and demo value.
enum MetricRegistry {
    /// Built once; `id.descriptor` is read on every render.
    static let all: [MetricID: MetricDescriptor] = Dictionary(
        uniqueKeysWithValues: MetricID.allCases.map { ($0, build($0)) }
    )

    private static func build(_ id: MetricID) -> MetricDescriptor {
        typealias T = HealthTypes
        return switch id {
        case .steps: make(id, "Steps", "figure.walk", .activity, .count, goal: 10_000, .sum(T.steps, .count()), demo: 6_428)
        case .distance: make(id, "Distance", "location.fill", .activity, .distance, goal: 5, .sum(T.distance, .mile()), demo: 3.1)
        case .activeEnergy: make(id, "Cal burned", "flame.fill", .activity, .energy, goal: 600, .sum(T.activeEnergy, .kilocalorie()), demo: 412)
        case .totalEnergy: make(id, "Cal burned", "flame.fill", .activity, .energy, goal: 2_400, .sum([T.activeEnergy, T.basalEnergy], .kilocalorie()), demo: 1_532)
        case .exerciseMinutes: make(id, "Exercise", "timer", .activity, .minutes, goal: 30, .sum(T.exerciseTime, .minute()), demo: 28)
        case .heartRate: make(id, "Heart rate", "heart.fill", .heart, .bpm, .latest(T.heartRate, .beatsPerMinute), demo: 72)
        case .restingHR: make(id, "Resting HR", "heart.text.square.fill", .heart, .bpm, .average(T.restingHeartRate, .beatsPerMinute), subtitle: "Resting", demo: 58)
        case .hrv: make(id, "HRV", "waveform.path.ecg", .heart, .milliseconds, .average(T.hrv, .milliseconds), demo: 52)
        case .recovery: make(id, "Recovery", "bolt.heart.fill", .heart, .percent, goal: 100, subtitle: "Estimate", demo: 71)
        case .weight: make(id, "Weight", "scalemass.fill", .body, .mass, .latest(T.bodyMass, .pound()), subtitle: "Latest", demo: 168.4)
        case .hydration: make(id, "Hydration", "drop.fill", .hydration, .volume, goal: 80, .sum(T.water, .fluidOunceUS()), opens: .water, demo: 44)
        case .sleep: make(id, "Sleep", "moon.stars.fill", .sleep, .duration, goal: 8, .sleep, demo: 7.2)
        case .stress: make(id, "Stress", "brain.head.profile", .mind, .score, demo: 31)
        case .caloriesIn: make(id, "Cal in", "fork.knife", .nutrition, .energy, goal: 2_000, .sum(T.dietaryEnergy, .kilocalorie()), demo: 1_640)
        case .protein: make(id, "Protein", "p.circle.fill", .nutrition, .grams, goal: 120, .sum(T.protein, .gram()), demo: 92)
        case .carbs: make(id, "Carbs", "c.circle.fill", .nutrition, .grams, goal: 220, .sum(T.carbs, .gram()), demo: 168)
        case .fat: make(id, "Fat", "f.circle.fill", .nutrition, .grams, goal: 70, .sum(T.fat, .gram()), demo: 54)
        case .activeZoneMinutes: make(id, "Zone minutes", "heart.circle", .activity, .minutes, demo: 24)
        case .floors: make(id, "Floors", "stairs", .activity, .integer, demo: 8)
        case .elevationGain: make(id, "Elevation", "mountain.2", .activity, .feet, demo: 96)
        case .oxygenSaturation: make(id, "Blood oxygen", "lungs", .heart, .percent, demo: 97)
        case .respiratoryRate: make(id, "Breathing rate", "wind", .heart, .breaths, demo: 15.2)
        case .skinTemperature: make(id, "Skin temperature", "thermometer.medium", .body, .celsius, demo: 33.4)
        case .bodyTemperature: make(id, "Body temperature", "thermometer.medium", .body, .celsius, demo: 36.6)
        case .vo2Max: make(id, "VO₂ max", "figure.run", .activity, .vo2, demo: 42)
        case .bodyFat: make(id, "Body fat", "figure.stand", .body, .percent, demo: 21.4)
        case .bloodGlucose: make(id, "Blood glucose", "drop", .body, .glucose, demo: 92)
        }
    }

    private static func make(
        _ id: MetricID, _ title: String, _ symbol: String, _ domain: MetricDomain, _ format: MetricFormat,
        goal: Double? = nil, _ healthKit: HealthQuery? = nil, subtitle: String? = nil, opens: TodaySheet? = nil, demo: Double
    ) -> MetricDescriptor {
        MetricDescriptor(id: id, title: title, symbol: symbol, domain: domain, format: format,
                         defaultGoal: goal, healthKit: healthKit, subtitle: subtitle, opens: opens, demo: demo)
    }
}

extension MetricID {
    var descriptor: MetricDescriptor { MetricRegistry.all[self]! }
}
