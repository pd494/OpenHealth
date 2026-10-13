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
        }
    }

    func number(_ value: Double) -> String {
        switch self {
        case .distance: value.formatted(.number.precision(.fractionLength(1)))
        case .duration: Duration.seconds(value * 3600).formatted(.units(allowed: [.hours, .minutes], width: .narrow))
        default: value.formatted(.number.precision(.fractionLength(0)))
        }
    }
}
