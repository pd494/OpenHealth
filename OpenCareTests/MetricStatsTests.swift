import XCTest
@testable import OpenCare

@MainActor
final class MetricStatsTests: XCTestCase {
    func testStepsStatsShowRemainingToGoal() {
        let manager = HealthManager.preview
        manager.stepGoal = 10_000
        let stats = manager.stats(for: .steps)
        XCTAssertEqual(stats.map(\.label), ["Distance", "Active", "Left"])
        XCTAssertEqual(stats.last?.value, "3,572 steps")
    }

    func testEveryGoalMetricHasAtMostThreeStats() {
        let manager = HealthManager.preview
        for id in MetricID.allCases where id.descriptor.supportsGoal {
            XCTAssertLessThanOrEqual(manager.stats(for: id).count, 3)
            XCTAssertFalse(manager.stats(for: id).isEmpty)
        }
    }
}
