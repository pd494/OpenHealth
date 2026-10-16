import Foundation

struct MetricSeries {
    let points: [(date: Date, value: Double)]
    let normalBand: ClosedRange<Double>

    private static let referenceDate = Date(timeIntervalSince1970: 1_792_065_600)

    var latest: (date: Date, value: Double) { points[points.count - 1] }

    var yDomain: ClosedRange<Double> {
        let low = min(points.map(\.value).min()!, normalBand.lowerBound)
        let high = max(points.map(\.value).max()!, normalBand.upperBound)
        let padding = (high - low) * 0.2
        return (low - padding)...(high + padding)
    }

    init(metric: MetricID, range: MetricRange) {
        let value = metric.descriptor.value
        let amplitude = max(abs(value) * 0.04, 0.2)
        switch metric {
        case .restingHeartRate: normalBand = 50...58
        case .hrv: normalBand = 55...85
        default: normalBand = (value - amplitude * 2)...(value + amplitude * 2)
        }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        points = (0..<range.pointCount).map { index in
            let offset = index - range.pointCount + 1
            let date = calendar.date(
                byAdding: range.dateComponent, value: offset * range.stride, to: Self.referenceDate
            )!
            let phase = Double(offset * range.stride)
            let variation = sin(phase * 1.7) + (cos(phase * 0.6) - 1) * 0.4
            return (date: date, value: value + amplitude * variation)
        }
    }
}
