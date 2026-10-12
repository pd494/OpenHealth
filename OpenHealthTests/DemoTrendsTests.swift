import XCTest
@testable import OpenHealth

final class DemoTrendsTests: XCTestCase {
    func testTrendsCoverSevenDaysEndingWithToday() {
        let trends = DemoTrends.trends()
        for (_, values) in trends {
            XCTAssertEqual(values.count, 7)
        }
        XCTAssertEqual(trends[.steps]?.last?.value, DemoMetricSource.values[.steps])
        XCTAssertEqual(trends[.activeEnergy]?.last?.value, DemoMetricSource.values[.activeEnergy])
        XCTAssertEqual(trends[.steps]?.last?.date, Calendar.current.startOfDay(for: .now))
    }
}
