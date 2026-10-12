import Foundation

enum DemoFitness {
    static let trendMetrics: [MetricID] = [.steps, .distance, .activeEnergy, .exerciseMinutes]

    static func trends(now: Date = .now) -> [MetricID: [DayValue]] {
        let today = Calendar.current.startOfDay(for: now)
        let steps: [Double] = [8_421, 10_230, 6_120, 9_440, 11_890, 7_305, 6_428]
        let series: [MetricID: [Double]] = [
            .steps: steps,
            .distance: steps.map { ($0 * 0.00048 * 10).rounded() / 10 },
            .activeEnergy: [380, 520, 290, 450, 610, 340, 412],
            .exerciseMinutes: [24, 41, 12, 35, 52, 22, 28]
        ]
        return series.mapValues { values in
            values.enumerated().map { DayValue(date: today.adding($0.offset - 6, .day), value: $0.element) }
        }
    }

    static func workouts(now: Date = .now) -> [WorkoutSummary] {
        let today = Calendar.current.startOfDay(for: now)
        return [
            WorkoutSummary(id: UUID(), name: "Run", systemImage: "figure.run", start: today.adding(-1, .day).adding(6 * 60 + 40, .minute), duration: 2_280, calories: 360, miles: 3.4),
            WorkoutSummary(id: UUID(), name: "Strength", systemImage: "dumbbell.fill", start: today.adding(-2, .day).adding(18 * 60, .minute), duration: 2_700, calories: 240, miles: nil),
            WorkoutSummary(id: UUID(), name: "Walk", systemImage: "figure.walk", start: today.adding(-4, .day).adding(12 * 60 + 15, .minute), duration: 1_980, calories: 130, miles: 1.6),
            WorkoutSummary(id: UUID(), name: "Ride", systemImage: "figure.outdoor.cycle", start: today.adding(-5, .day).adding(8 * 60, .minute), duration: 3_600, calories: 420, miles: 11.8)
        ]
    }
}
