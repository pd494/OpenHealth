import XCTest
@testable import OpenHealth

final class GoogleHealthParsingTests: XCTestCase {
    private func decode<Response: Decodable>(_ type: Response.Type, _ json: String) throws -> Response {
        try JSONDecoder.googleHealth.decode(type, from: Data(json.utf8))
    }

    func testDailyStepsUsesReconciledCountAndCivilDate() throws {
        let response = try decode(DailyStepsResponse.self, """
            {"rollupDataPoints": [
                {"civilStartTime": {"date": {"year": 2026, "month": 9, "day": 28}}, "steps": {"countSum": "6428"}},
                {"civilStartTime": {"date": {"year": 2026, "month": 9, "day": 27}}, "steps": {"countSum": "9012"}}
            ]}
            """)
        XCTAssertEqual(response.days.map(\.count), [6_428, 9_012])
        XCTAssertEqual(Calendar.current.component(.day, from: try XCTUnwrap(response.days.first?.date)), 28)
    }

    func testDaysWithoutStepsAreSkippedAndEmptyResponseIsEmpty() throws {
        let sparse = try decode(DailyStepsResponse.self, """
            {"rollupDataPoints": [{"civilStartTime": {"date": {"year": 2026, "month": 9, "day": 28}}}]}
            """)
        XCTAssertTrue(sparse.days.isEmpty)
        XCTAssertTrue(try decode(DailyStepsResponse.self, "{}").days.isEmpty)
    }

    func testOnlyPairedTrackerAirIsSelected() throws {
        let response = try decode(PairedDevicesResponse.self, """
            {"pairedDevices": [
                {"deviceType": "SCALE", "deviceVersion": "Aria Air"},
                {"deviceType": "TRACKER", "deviceVersion": "Fitbit Air", "lastSyncTime": "2026-09-28T21:05:00Z"}
            ]}
            """)
        let air = try XCTUnwrap(response.air)
        XCTAssertEqual(air.name, "Fitbit Air")
        XCTAssertNotNil(air.lastSync)
    }

    func testSleepUsesLatestMainSessionInsteadOfLongestOldSession() throws {
        let response = try decode(SleepResponse.self, """
            {"dataPoints": [
                {"sleep": {"interval": {"endTime": "2026-09-28T14:00:00Z"}, "summary": {"minutesAsleep": "390"}}},
                {"sleep": {"interval": {"endTime": "2026-09-27T14:00:00Z"}, "summary": {"minutesAsleep": "480"}}}
            ]}
            """)
        XCTAssertEqual(response.lastNightHours, 6.5)
    }

    func testDailyMetricsAreNewestFirstAndReadTheRightField() throws {
        let response = try decode(DailyMetricResponse.self, """
            {"dataPoints": [
                {"dailyRestingHeartRate": {"date": {"year": 2026, "month": 9, "day": 27}, "beatsPerMinute": 58}},
                {"dailyRestingHeartRate": {"date": {"year": 2026, "month": 9, "day": 28}, "beatsPerMinute": "60"}},
                {"dailyHeartRateVariability": {"date": {"year": 2026, "month": 9, "day": 28}, "averageHeartRateVariabilityMilliseconds": 42.5}}
            ]}
            """)
        XCTAssertEqual(response.metrics(for: .restingHeartRate).map(\.value), [60, 58])
        XCTAssertEqual(response.metrics(for: .heartRateVariability).map(\.value), [42.5])
    }

    func testFractionalSecondTimestampsDecode() throws {
        let response = try decode(PairedDevicesResponse.self, """
            {"pairedDevices": [{"deviceType": "TRACKER", "deviceVersion": "Fitbit Air", "lastSyncTime": "2026-09-28T21:05:00.123Z"}]}
            """)
        XCTAssertNotNil(response.air?.lastSync)
    }
}
