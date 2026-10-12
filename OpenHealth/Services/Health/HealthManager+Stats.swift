import Foundation

extension HealthManager {
    /// Up to three supporting figures for a goal ring, skipping any that are another visible ring's headline.
    func stats(for id: MetricID, hiding rings: [MetricID]) -> [MetricStat] {
        let shown = rings.map(DashboardLayout.canonical)
        let unique = candidates(for: id).filter { stat in
            stat.metric.map { !shown.contains(DashboardLayout.canonical($0)) } ?? true
        }
        return Array(unique.prefix(3))
    }

    private func candidates(for id: MetricID) -> [MetricStat] {
        switch DashboardLayout.canonical(id) {
        case .steps: [stat("Distance", .distance), stat("Active", .exerciseMinutes), left(.steps), stat("Cal burned", .activeEnergy)]
        case .recovery: [stat("HRV", .hrv), stat("Resting", .restingHR), stat("Sleep", .sleep), hrvDelta]
        case .sleep: [stat("Goal", goalOf(.sleep)), left(.sleep), stat("Recovery", .recovery), clock("Bedtime", sleepNight?.bedtime), clock("Wake", sleepNight?.wakeTime)]
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
        MetricStat(label: label, value: text(id, value(id).value), metric: id)
    }

    private func stat(_ label: String, _ goal: (MetricID, Double?)) -> MetricStat {
        MetricStat(label: label, value: text(goal.0, goal.1))
    }

    private var hrvDelta: MetricStat {
        let delta = hrv.today.flatMap { today in hrv.baseline.map { today - $0 } }
        let text = delta.map { $0.formatted(.number.sign(strategy: .always()).precision(.fractionLength(0))) + " ms" }
        return MetricStat(label: "HRV vs avg", value: text ?? "—")
    }

    private func clock(_ label: String, _ date: Date?) -> MetricStat {
        MetricStat(label: label, value: date?.formatted(date: .omitted, time: .shortened) ?? "—")
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
