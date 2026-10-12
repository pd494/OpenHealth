extension HealthManager {
    func value(_ id: MetricID) -> MetricValue {
        let amount = id == .hydration ? waterOunces : readings[id]
        return MetricValue(id: id, value: amount, goal: goal(for: id), subtitle: subtitle(for: id))
    }

    private func goal(for id: MetricID) -> Double? {
        switch id {
        case .steps: Double(stepGoal)
        case .sleep: sleepGoal
        case .hydration: waterGoal
        default: id.descriptor.defaultGoal
        }
    }

    private func subtitle(for id: MetricID) -> String? {
        switch id {
        case .hrv:
            guard hrv.today != nil, hrv.baseline != nil else { return nil }
            return hrv.isBelowBaseline ? "Below baseline" : "In range"
        case .heartRate, .weight: return "Latest"
        case .restingHR: return "Resting"
        case .recovery: return "Estimate"
        default: return nil
        }
    }
}
