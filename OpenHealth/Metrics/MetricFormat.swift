import Foundation

enum MetricFormat {
    case count
    case distance
    case energy
    case volume
    case grams
    case minutes
    case duration
    case percent
    case bpm
    case milliseconds
    case pounds
    case floors
    case days
    case inRange

    var unit: String {
        switch self {
        case .count: "steps"
        case .distance: "mi"
        case .energy: "kcal"
        case .volume: "oz"
        case .grams: "g"
        case .minutes: "min"
        case .duration: ""
        case .percent: "%"
        case .bpm: "bpm"
        case .milliseconds: "ms"
        case .pounds: "lb"
        case .floors: "floors"
        case .days: "days"
        case .inRange: "in range"
        }
    }

    func number(_ value: Double) -> String {
        switch self {
        case .distance, .pounds: value.formatted(.number.precision(.fractionLength(1)))
        case .duration: Duration.seconds(value * 3600).formatted(.units(allowed: [.hours, .minutes], width: .narrow))
        default: value.formatted(.number.precision(.fractionLength(0)))
        }
    }
}
