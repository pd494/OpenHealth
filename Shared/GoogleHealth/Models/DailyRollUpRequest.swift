import Foundation

struct DailyRollUpRequest: Encodable {
    struct Boundary: Encodable {
        struct Midnight: Encodable {
            let hours = 0, minutes = 0, seconds = 0, nanos = 0
        }

        let date: CivilDate
        let time = Midnight()
    }

    struct DateRange: Encodable {
        let start: Boundary
        let end: Boundary
    }

    let range: DateRange
    let windowSizeDays = 1
    let dataSourceFamily: String

    init(from start: Date, to end: Date, dataSourceFamily: String) {
        range = DateRange(start: Boundary(date: CivilDate(start)), end: Boundary(date: CivilDate(end)))
        self.dataSourceFamily = dataSourceFamily
    }
}
