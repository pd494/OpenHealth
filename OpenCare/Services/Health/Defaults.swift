import Foundation

enum Defaults {
    struct Key<Value> {
        let name: String
    }

    static subscript<Value>(key: Key<Value>) -> Value? {
        get { UserDefaults.standard.object(forKey: key.name) as? Value }
        set { UserDefaults.standard.set(newValue, forKey: key.name) }
    }
}

extension Defaults.Key where Value == Int {
    static var stepGoal: Self { .init(name: "stepGoal") }
}

extension Defaults.Key where Value == Double {
    static var sleepGoal: Self { .init(name: "sleepGoal") }
    static var waterGoal: Self { .init(name: "waterGoal") }
    static var googleSharedStepsTotal: Self { .init(name: "googleSharedStepsTotal") }
}

extension Defaults.Key where Value == Bool {
    static var appleHealthConnected: Self { .init(name: "appleHealthConnected") }
    static var googleStepWakeupsEnabled: Self { .init(name: "googleStepWakeupsEnabled") }
}

extension Defaults.Key where Value == String {
    static var stepSource: Self { .init(name: "stepSource") }
}

extension Defaults.Key where Value == Date {
    static var googleSharedStepsDay: Self { .init(name: "googleSharedStepsDay") }
}

extension Defaults.Key where Value == Data {
    static var localWater: Self { .init(name: "localWaterRecord") }
}
