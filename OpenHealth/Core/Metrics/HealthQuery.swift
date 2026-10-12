import HealthKit

/// How a metric is read from HealthKit. Declared once per metric in `MetricRegistry`.
enum HealthQuery: @unchecked Sendable {
    /// Daily total across one or more quantity types (e.g. active + basal energy).
    case sum([HKQuantityType], HKUnit)
    /// Daily average.
    case average(HKQuantityType, HKUnit)
    /// Most recent sample, regardless of day.
    case latest(HKQuantityType, HKUnit)
    /// Hours asleep for the night ending on the day.
    case sleep

    static func sum(_ type: HKQuantityType, _ unit: HKUnit) -> HealthQuery { .sum([type], unit) }

    /// The single type behind a daily-summed metric, which is what a 7-day trend can chart.
    var trendType: (HKQuantityType, HKUnit)? {
        guard case .sum(let types, let unit) = self, types.count == 1 else { return nil }
        return (types[0], unit)
    }

    var sampleTypes: [HKSampleType] {
        switch self {
        case .sum(let types, _): types
        case .average(let type, _), .latest(let type, _): [type]
        case .sleep: [HealthTypes.sleep]
        }
    }
}
