import XCTest
@testable import OpenCare

final class StressTests: XCTestCase {
    private func score(hrv: Double = 50, heartRate: Double = 60) -> Double {
        StressScore.score(hrv: hrv, hrvBaseline: 50, heartRate: heartRate, restingHR: 60)
    }

    func testRelaxedStateScoresZeroAndDepletedStateScoresOneHundred() {
        XCTAssertEqual(StressScore.score(hrv: 70, hrvBaseline: 50, heartRate: 55, restingHR: 60), 0)
        XCTAssertEqual(StressScore.score(hrv: 20, hrvBaseline: 50, heartRate: 110, restingHR: 60), 100)
    }

    func testScoreIsClampedAndMonotonic() {
        XCTAssertEqual(score(hrv: 500, heartRate: 1), 0)
        XCTAssertEqual(score(hrv: 0.1, heartRate: 500), 100)
        XCTAssertLessThan(score(hrv: 60), score(hrv: 40))
        XCTAssertLessThan(score(heartRate: 62), score(heartRate: 80))
    }

    func testHeartRateAndHRVWeights() {
        XCTAssertEqual(score(hrv: 20, heartRate: 60), 60, accuracy: 0.001)
        XCTAssertEqual(score(hrv: 70, heartRate: 96), 40, accuracy: 0.001)
    }

    func testBandBoundaries() {
        XCTAssertEqual(StressScore.band(0), .low)
        XCTAssertEqual(StressScore.band(33.9), .low)
        XCTAssertEqual(StressScore.band(34), .medium)
        XCTAssertEqual(StressScore.band(66.9), .medium)
        XCTAssertEqual(StressScore.band(67), .high)
        XCTAssertEqual(StressScore.band(100), .high)
    }

    func testSamplerCarriesHRVForwardButNotBeyondTwelveHours() {
        let start = Date(timeIntervalSinceReferenceDate: 0)
        let hrv = [DayValue(date: start, value: 50)]
        let heartRate = [
            DayValue(date: start.addingTimeInterval(3600), value: 60),
            DayValue(date: start.addingTimeInterval(13 * 3600), value: 60)
        ]
        let points = StressSampler.points(heartRate: heartRate, hrv: hrv, hrvBaseline: 50, restingHR: 60)
        XCTAssertEqual(points.map(\.date), [start.addingTimeInterval(3600)])
    }

    func testSamplerNeedsPositiveBaselines() {
        let sample = [DayValue(date: .now, value: 60)]
        XCTAssertTrue(StressSampler.points(heartRate: sample, hrv: sample, hrvBaseline: 0, restingHR: 60).isEmpty)
        XCTAssertTrue(StressSampler.points(heartRate: sample, hrv: sample, hrvBaseline: 50, restingHR: 0).isEmpty)
    }

    func testDurationsAndSharesFollowBands() {
        let now = Date.now
        let points = [10, 20, 50, 80].map { StressPoint(date: now.addingTimeInterval(Double($0)), score: Double($0)) }
        let day = StressDay(points: points, interval: 900, sleepWindow: nil, week: [])
        XCTAssertEqual(day.totalDuration, 3600)
        XCTAssertEqual(day.duration(of: .low), 1800)
        XCTAssertEqual(day.share(of: .medium), 0.25)
        XCTAssertEqual(day.share(of: .high), 0.25)
        XCTAssertEqual(day.average, 40)
    }

    func testNormalRangeNeedsThreePriorDays() {
        let week = [30, 40, 50, 40].enumerated().map { DayValue(date: Date(timeIntervalSince1970: Double($0.offset)), value: Double($0.element)) }
        let day = StressDay(points: [], interval: 900, sleepWindow: nil, week: week)
        XCTAssertEqual(day.normalRange?.lowerBound ?? 0, 40 - (200.0 / 3).squareRoot(), accuracy: 0.001)
        XCTAssertNil(StressDay(points: [], interval: 900, sleepWindow: nil, week: Array(week.prefix(3))).normalRange)
    }

    func testDailyAveragesGroupByDay() {
        let day = Calendar.current.startOfDay(for: .now)
        let points = [StressPoint(date: day, score: 20), StressPoint(date: day.addingTimeInterval(60), score: 40)]
        XCTAssertEqual(StressSampler.dailyAverages(points).map(\.value), [30])
    }
}
