import Foundation

enum MetricFormat: Sendable {
    case count
    case distance
    case energy
    case bpm
    case milliseconds
    case mass
    case volume
    case grams
    case minutes
    case duration
    case score
    case percent

    var unit: String {
        switch self {
        case .count: "steps"
        case .distance: "mi"
        case .energy: "kcal"
        case .bpm: "bpm"
        case .milliseconds: "ms"
        case .mass: "lb"
        case .volume: "oz"
        case .grams: "g"
        case .minutes: "min"
        case .duration, .score: ""
        case .percent: "%"
        }
    }

    func number(_ value: Double) -> String {
        switch self {
        case .distance, .mass: value.formatted(.number.precision(.fractionLength(1)))
        case .duration: Duration.seconds(value * 3600).formatted(.units(allowed: [.hours, .minutes], width: .narrow))
        default: value.formatted(.number.precision(.fractionLength(0)))
        }
    }
}
