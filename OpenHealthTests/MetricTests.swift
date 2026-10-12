import XCTest
@testable import OpenHealth

final class MetricTests: XCTestCase {
    func testDescriptorsMatchTheirIDs() {
        for id in MetricID.allCases {
            XCTAssertEqual(id.descriptor.id, id)
        }
    }

    func testProgressNeedsValueAndGoal() {
        XCTAssertEqual(MetricValue(id: .steps, value: 5_000, goal: 10_000, subtitle: nil).progress, 0.5)
        XCTAssertNil(MetricValue(id: .steps, value: nil, goal: 10_000, subtitle: nil).progress)
        XCTAssertNil(MetricValue(id: .weight, value: 168, goal: nil, subtitle: nil).progress)
    }

    func testFormatting() {
        XCTAssertEqual(MetricFormat.count.number(6_428), "6,428")
        XCTAssertEqual(MetricFormat.distance.number(3.14), "3.1")
        XCTAssertEqual(MetricValue(id: .hrv, value: nil, goal: nil, subtitle: nil).number, "—")
    }

    func testDemoSourceFiltersRequestedIDs() async throws {
        let values = try await DemoMetricSource().values(for: [.steps, .hrv], on: .now)
        XCTAssertEqual(Set(values.keys), [.steps, .hrv])
        XCTAssertEqual(DemoMetricSource.values.count, MetricID.allCases.count)
    }

    func testGoogleSourceOnlyReportsWhatItHas() async throws {
        let source = GoogleMetricSource(steps: 900, sleepHours: nil, recovery: 70, hrv: nil, restingHR: nil)
        let values = try await source.values(for: Set(MetricID.allCases), on: .now)
        XCTAssertEqual(values, [.steps: 900, .recovery: 70])
    }

    @MainActor
    func testManagerValueUsesGoalsAndDemoReadings() {
        let manager = HealthManager.preview
        let steps = manager.value(.steps)
        XCTAssertEqual(steps.value, 6_428)
        XCTAssertEqual(steps.goal, Double(manager.stepGoal))
        XCTAssertEqual(manager.value(.hydration).value, manager.waterOunces)
    }
}
