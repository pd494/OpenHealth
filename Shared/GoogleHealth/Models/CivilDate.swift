import Foundation

struct CivilDate: Codable {
    let year: Int
    let month: Int
    let day: Int

    var startOfDay: Date? {
        Calendar.current.date(from: DateComponents(year: year, month: month, day: day))
    }

    init(_ date: Date) {
        let calendar = Calendar.current
        year = calendar.component(.year, from: date)
        month = calendar.component(.month, from: date)
        day = calendar.component(.day, from: date)
    }
}
