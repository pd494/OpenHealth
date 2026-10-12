import Foundation

enum LocalWater {
    private struct Record: Codable {
        let date: Date
        let ounces: Double
    }

    static func today() -> Double {
        guard let data = Defaults[.localWater],
              let record = try? JSONDecoder().decode(Record.self, from: data),
              Calendar.current.isDateInToday(record.date) else { return 0 }
        return record.ounces
    }

    static func save(_ ounces: Double) {
        Defaults[.localWater] = try? JSONEncoder().encode(Record(date: .now, ounces: ounces))
    }
}
