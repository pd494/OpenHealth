import XCTest
@testable import OpenHealth

final class DemoFitnessTests: XCTestCase {
    func testTrendsCoverSevenDaysEndingWithToday() {
        let trends = DemoFitness.trends()
        for id in DemoFitness.trendMetrics {
            XCTAssertEqual(trends[id]?.count, 7)
        }
        XCTAssertEqual(trends[.steps]?.last?.value, DemoMetricSource.values[.steps])
        XCTAssertEqual(trends[.activeEnergy]?.last?.value, DemoMetricSource.values[.activeEnergy])
        XCTAssertEqual(trends[.steps]?.last?.date, Calendar.current.startOfDay(for: .now))
    }

    func testWorkoutsAreNewestFirst() {
        let starts = DemoFitness.workouts().map(\.start)
        XCTAssertEqual(starts, starts.sorted(by: >))
    }
}
