import HealthKit

extension WorkoutSummary {
    init(_ workout: HKWorkout) {
        let (name, symbol) = Self.describe(workout.workoutActivityType)
        let distanceTypes = [HKQuantityType(.distanceWalkingRunning), HKQuantityType(.distanceCycling)]
        self.init(
            id: workout.uuid,
            name: name,
            systemImage: symbol,
            start: workout.startDate,
            duration: workout.duration,
            calories: workout.statistics(for: HKQuantityType(.activeEnergyBurned))?.sumQuantity()?.doubleValue(for: .kilocalorie()),
            miles: distanceTypes.lazy.compactMap { workout.statistics(for: $0)?.sumQuantity()?.doubleValue(for: .mile()) }.first
        )
    }

    private static func describe(_ type: HKWorkoutActivityType) -> (String, String) {
        switch type {
        case .running: ("Run", "figure.run")
        case .walking: ("Walk", "figure.walk")
        case .cycling: ("Ride", "figure.outdoor.cycle")
        case .swimming: ("Swim", "figure.pool.swim")
        case .hiking: ("Hike", "figure.hiking")
        case .yoga: ("Yoga", "figure.yoga")
        case .functionalStrengthTraining, .traditionalStrengthTraining: ("Strength", "dumbbell.fill")
        case .highIntensityIntervalTraining: ("HIIT", "bolt.heart.fill")
        default: ("Workout", "figure.mixed.cardio")
        }
    }
}
