extension HealthManager {
    func value(_ id: MetricID) -> MetricValue {
        let amount: Double?
        if id == .hydration && stepSource == .google {
            let local = LocalWater.today()
            amount = readings[id].map { $0 + local } ?? (local > 0 ? local : nil)
        } else {
            amount = id == .hydration ? waterOunces : readings[id]
        }
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
        case .heartRate: return stepSource == .google ? "Today’s average" : "Latest"
        case .stress: return readings[.stress].map { StressScore.band($0).title }
        default: return id.descriptor.subtitle
        }
    }
}
