extension HealthManager {
    /// Up to three supporting figures shown beside or beneath a goal ring.
    func stats(for id: MetricID) -> [MetricStat] {
        switch DashboardLayout.canonical(id) {
        case .steps: [stat("Distance", .distance), stat("Active", .exerciseMinutes), left(.steps)]
        case .recovery: [stat("HRV", .hrv), stat("Resting", .restingHR), stat("Sleep", .sleep)]
        case .sleep: [stat("Goal", goalOf(.sleep)), left(.sleep), stat("Recovery", .recovery)]
        case .hydration: [left(.hydration), stat("Goal", goalOf(.hydration)), percent(.hydration)]
        case .activeEnergy: [stat("Active", .activeEnergy), stat("Total", .totalEnergy), stat("Exercise", .exerciseMinutes)]
        case .distance: [stat("Steps", .steps), stat("Cal burned", .activeEnergy), stat("Goal", goalOf(.distance))]
        case .exerciseMinutes: [stat("Cal burned", .activeEnergy), stat("Steps", .steps), stat("Goal", goalOf(.exerciseMinutes))]
        case .caloriesIn: [left(.caloriesIn), stat("Protein", .protein), stat("Carbs", .carbs)]
        default: [stat("Goal", goalOf(id)), left(id)]
        }
    }

    private func text(_ id: MetricID, _ amount: Double?) -> String {
        guard let amount else { return "—" }
        let format = id.descriptor.format
        return format.unit == "%" ? format.number(amount) + "%" : [format.number(amount), format.unit].filter { !$0.isEmpty }.joined(separator: " ")
    }

    private func stat(_ label: String, _ id: MetricID) -> MetricStat {
        MetricStat(label: label, value: text(id, value(id).value))
    }

    private func stat(_ label: String, _ goal: (MetricID, Double?)) -> MetricStat {
        MetricStat(label: label, value: text(goal.0, goal.1))
    }

    private func goalOf(_ id: MetricID) -> (MetricID, Double?) { (id, value(id).goal) }

    private func left(_ id: MetricID) -> MetricStat {
        let reading = value(id)
        let remaining = reading.value.flatMap { amount in reading.goal.map { max($0 - amount, 0) } }
        return MetricStat(label: "Left", value: text(id, remaining))
    }

    private func percent(_ id: MetricID) -> MetricStat {
        MetricStat(label: "Done", value: value(id).progress.map { $0.formatted(.percent.precision(.fractionLength(0))) } ?? "—")
    }
}
