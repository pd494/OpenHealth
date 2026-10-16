import Foundation

/// One night, from getting into bed to getting up. The data is a hard-coded placeholder until a real source is wired in.
struct SleepNight {
    let bedtime: Date
    let segments: [SleepSegment]
    let score: Int

    var inBedMinutes: Int { segments.last?.end ?? 0 }
    var wake: Date { date(atMinute: inBedMinutes) }
    var asleepMinutes: Int { inBedMinutes - minutes(in: .awake) }
    var scoreLabel: String { score >= 85 ? "Good" : score >= 70 ? "Fair" : "Poor" }
    var goalProgress: Double { Double(asleepMinutes) / 60 / MetricID.sleep.descriptor.goal }

    func minutes(in stage: SleepStage) -> Int {
        segments.lazy.filter { $0.stage == stage }.reduce(0) { $0 + $1.minutes }
    }

    func segment(atMinute minute: Double) -> SleepSegment? {
        segments.first { minute < Double($0.end) } ?? segments.last
    }

    func date(atMinute minute: Int) -> Date {
        bedtime.addingTimeInterval(Double(minute) * 60)
    }

    /// "7h 12m". Hours stay when there are none, so the stage tiles line up.
    static func duration(_ minutes: Int) -> String {
        Duration.seconds(minutes * 60).formatted(.units(allowed: [.hours, .minutes], width: .narrow, zeroValueUnits: .show(length: 1)))
    }

    /// "11:42p", the compact form the chart's time axis uses.
    static func tick(_ date: Date) -> String {
        date.formatted(.dateTime.hour(.defaultDigits(amPM: .narrow)).minute()).filter { !$0.isWhitespace }
    }
}

extension SleepNight {
    static let demo: SleepNight = {
        let stages: [(SleepStage, Int)] = [
            (.awake, 9), (.core, 28), (.deep, 42), (.core, 17), (.rem, 20), (.core, 25), (.deep, 28), (.core, 13),
            (.awake, 4), (.rem, 26), (.core, 32), (.deep, 12), (.core, 28), (.rem, 38), (.core, 22), (.awake, 5),
            (.rem, 36), (.core, 26), (.awake, 6), (.core, 16), (.rem, 23),
        ]
        var start = 0
        let segments = stages.enumerated().map { index, entry in
            defer { start += entry.1 }
            return SleepSegment(id: index, stage: entry.0, start: start, minutes: entry.1)
        }
        let calendar = Calendar.current
        let bedtime = calendar.date(byAdding: .minute, value: -18, to: calendar.startOfDay(for: .now))!
        return SleepNight(bedtime: bedtime, segments: segments, score: 86)
    }()
}
