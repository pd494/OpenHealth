import Foundation

enum DemoTrends {

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
}
