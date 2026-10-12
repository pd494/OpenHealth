import HealthKit

enum HealthTypes {
    static let steps = HKQuantityType(.stepCount)
    static let water = HKQuantityType(.dietaryWater)
    static let sleep = HKCategoryType(.sleepAnalysis)
    static let hrv = HKQuantityType(.heartRateVariabilitySDNN)
    static let restingHeartRate = HKQuantityType(.restingHeartRate)

    static let distance = HKQuantityType(.distanceWalkingRunning)
    static let activeEnergy = HKQuantityType(.activeEnergyBurned)
    static let basalEnergy = HKQuantityType(.basalEnergyBurned)
    static let exerciseTime = HKQuantityType(.appleExerciseTime)
    static let heartRate = HKQuantityType(.heartRate)
    static let bodyMass = HKQuantityType(.bodyMass)
    static let dietaryEnergy = HKQuantityType(.dietaryEnergyConsumed)
    static let protein = HKQuantityType(.dietaryProtein)
    static let carbs = HKQuantityType(.dietaryCarbohydrates)
    static let fat = HKQuantityType(.dietaryFatTotal)

    /// Everything Today reads: each metric's query plus sleep stages.
    static let all: [HKSampleType] = {
        let types = [sleep] + MetricID.allCases.flatMap { $0.descriptor.healthKit?.sampleTypes ?? [] }
        return Array(Set(types))
    }()
}

extension HKUnit {
    static let milliseconds = HKUnit.secondUnit(with: .milli)
    static let beatsPerMinute = HKUnit.count().unitDivided(by: .minute())
}
