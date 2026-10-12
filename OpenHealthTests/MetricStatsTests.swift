import XCTest
@testable import OpenHealth

@MainActor
final class MetricStatsTests: XCTestCase {
    func testStepsStatsShowRemainingToGoal() {
        let manager = HealthManager.preview
        manager.stepGoal = 10_000
        let stats = manager.stats(for: .steps, hiding: [])
        XCTAssertEqual(stats.map(\.label), ["Distance", "Active", "Left"])
        XCTAssertEqual(stats.last?.value, "3,572 steps")
    }

    func testEveryGoalMetricHasAtMostThreeStats() {
        let manager = HealthManager.preview
        for id in MetricID.allCases where id.descriptor.defaultGoal != nil {
            XCTAssertLessThanOrEqual(manager.stats(for: id, hiding: []).count, 3)
            XCTAssertFalse(manager.stats(for: id, hiding: []).isEmpty)
        }
    }

    func testStatsSkipMetricsShownAsOtherRings() {
        let manager = HealthManager.preview
        let rings: [MetricID] = [.steps, .recovery, .sleep]
        let recovery = manager.stats(for: .recovery, hiding: rings).map(\.label)
        let sleep = manager.stats(for: .sleep, hiding: rings).map(\.label)
        XCTAssertEqual(recovery, ["HRV", "Resting", "HRV vs avg"])
        XCTAssertEqual(sleep, ["Goal", "Left", "Bedtime"])
    }
}
