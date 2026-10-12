import Foundation

struct DayValue: Identifiable, Equatable {
    let date: Date
    let value: Double

    var id: Date { date }
}
