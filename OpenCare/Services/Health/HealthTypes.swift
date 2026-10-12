import HealthKit

enum HealthTypes {
    static let steps = HKQuantityType(.stepCount)
    static let water = HKQuantityType(.dietaryWater)
    static let sleep = HKCategoryType(.sleepAnalysis)
    static let hrv = HKQuantityType(.heartRateVariabilitySDNN)
    static let restingHeartRate = HKQuantityType(.restingHeartRate)

    static let all: [HKSampleType] = [steps, water, sleep, hrv, restingHeartRate]
}

extension HKUnit {
    static let milliseconds = HKUnit.secondUnit(with: .milli)
    static let beatsPerMinute = HKUnit.count().unitDivided(by: .minute())
}
