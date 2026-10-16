import Foundation

enum MetricRange: String, CaseIterable {
    case week = "1W"
    case month = "1M"
    case sixMonths = "6M"
    case year = "1Y"

    var pointCount: Int {
        switch self {
        case .week: 7
        case .month: 30
        case .sixMonths: 26
        case .year: 12
        }
    }

    var dateComponent: Calendar.Component { self == .year ? .month : .day }
    var stride: Int { self == .sixMonths ? 7 : 1 }
}
