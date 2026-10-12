import Foundation

struct SharedSnapshot: Codable {
    var steps: Int
    var stepGoal: Int
    var waterOunces: Double
    var waterGoal: Double
    var sourceName: String
    var updatedAt: Date
    var stepsCheckedAt: Date
    var waterCheckedAt: Date
    var deviceSyncedAt: Date?

    var stepsProgress: Double { Double(steps) / Double(stepGoal) }
    var waterProgress: Double { waterOunces / waterGoal }
    var isFromGoogle: Bool { sourceName == StepSource.google.displayName }

    static let empty = SharedSnapshot(
        steps: 0, stepGoal: 10_000, waterOunces: 0, waterGoal: 80,
        sourceName: "OpenCare", updatedAt: .distantPast,
        stepsCheckedAt: .distantPast, waterCheckedAt: .distantPast,
        deviceSyncedAt: nil
    )

    static let sample = SharedSnapshot(
        steps: 6_428, stepGoal: 10_000, waterOunces: 44, waterGoal: 80,
        sourceName: StepSource.demo.displayName, updatedAt: .now,
        stepsCheckedAt: .now, waterCheckedAt: .now, deviceSyncedAt: .now
    )
}
