import XCTest
@testable import OpenHealth

final class SleepNightTests: XCTestCase {
    private let start = Date(timeIntervalSinceReferenceDate: 0)

    private func segment(_ stage: SleepStage, from minute: Int, to end: Int) -> SleepSegment {
        SleepSegment(stage: stage, start: start.adding(minute, .minute), end: start.adding(end, .minute))
    }

    func testAsleepHoursExcludeAwakeTime() {
        let night = SleepNight(segments: [
            segment(.awake, from: 0, to: 30),
            segment(.core, from: 30, to: 150),
            segment(.deep, from: 150, to: 210)
        ])
        XCTAssertEqual(night.asleepHours, 3)
        XCTAssertEqual(night.duration(of: .awake), 1_800)
        XCTAssertEqual(night.bedtime, start)
        XCTAssertEqual(night.wakeTime, start.adding(210, .minute))
    }

    func testDemoNightMatchesDemoSleepMetric() {
        XCTAssertEqual(DemoSleep.night().asleepHours, DemoMetricSource.values[.sleep] ?? 0, accuracy: 0.001)
        XCTAssertEqual(DemoSleep.week(tonight: 7.2).count, 7)
    }
}
