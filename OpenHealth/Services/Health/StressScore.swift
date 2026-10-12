import Foundation

/// Starter heuristic: the weights and cut-offs are not clinically validated.
enum StressScore {
    /// Scores below this are low; the band is 0..<34.
    static let mediumThreshold = 34.0
    /// Scores at or above this are high; medium is 34..<67.
    static let highThreshold = 67.0

    private static let hrvWeight = 0.6
    private static let relaxedHRVRatio = 1.25
    private static let depletedHRVRatio = 0.5
    private static let elevatedHeartRatio = 1.6

    /// 0 means HRV at least 25 % above baseline with heart rate at resting level;
    /// 100 means HRV at half of baseline with heart rate 60 % above resting.
    /// All inputs must be positive.
    static func score(hrv: Double, hrvBaseline: Double, heartRate: Double, restingHR: Double) -> Double {
        let hrvStress = unit((relaxedHRVRatio - hrv / hrvBaseline) / (relaxedHRVRatio - depletedHRVRatio))
        let heartStress = unit((heartRate / restingHR - 1) / (elevatedHeartRatio - 1))
        return (hrvWeight * hrvStress + (1 - hrvWeight) * heartStress) * 100
    }

    static func band(_ score: Double) -> StressBand {
        switch score {
        case ..<mediumThreshold: .low
        case ..<highThreshold: .medium
        default: .high
        }
    }

    private static func unit(_ value: Double) -> Double { min(max(value, 0), 1) }
}
