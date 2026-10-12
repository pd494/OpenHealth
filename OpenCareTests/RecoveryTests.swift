import XCTest
@testable import OpenCare

final class RecoveryTests: XCTestCase {
    func testBaselineNeedsAtLeastThreePriorDays() {
        XCTAssertNil(Recovery.baseline(of: [40, 42]))
        XCTAssertEqual(Recovery.baseline(of: [40, 42, 44]), 42)
    }

    func testScoreIsNilWithoutVitalsOrSleep() {
        let vital = Vital(today: 50, baseline: 50)
        XCTAssertNil(Recovery.score(sleep: 8, goal: 8, hrv: Vital(today: 50, baseline: nil), rhr: vital))
        XCTAssertNil(Recovery.score(sleep: 0, goal: 8, hrv: vital, rhr: vital))
    }

    func testPerfectNightScoresOneHundred() {
        let vital = Vital(today: 50, baseline: 50)
        XCTAssertEqual(Recovery.score(sleep: 8, goal: 8, hrv: vital, rhr: vital), 100)
    }

    func testShortSleepAndDepressedVitalsLowerTheScore() {
        let score = Recovery.score(
            sleep: 4, goal: 8,
            hrv: Vital(today: 30, baseline: 60),   // half of baseline
            rhr: Vital(today: 80, baseline: 60)    // elevated resting heart rate
        )
        // 25 (sleep) + 12.5 (HRV) + 18.75 (resting HR) = 56.25
        XCTAssertEqual(score, 56)
    }

    func testVitalDirection() {
        XCTAssertTrue(Vital(today: 40, baseline: 50).isBelowBaseline)
        XCTAssertTrue(Vital(today: 60, baseline: 50).isAboveBaseline)
        XCTAssertFalse(Vital(today: 40, baseline: nil).isBelowBaseline)
    }
}
