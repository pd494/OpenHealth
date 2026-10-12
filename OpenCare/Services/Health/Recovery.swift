import Foundation

/// Starter heuristic: the weights are not clinically validated.
enum Recovery {
    static func baseline(of history: [Double]) -> Double? {
        guard history.count >= 3 else { return nil }
        return history.reduce(0, +) / Double(history.count)
    }

    static func score(sleep: Double, goal: Double, hrv: Vital, rhr: Vital) -> Int? {
        guard let hrvToday = hrv.today, let hrvBaseline = hrv.baseline,
              let rhrToday = rhr.today, let rhrBaseline = rhr.baseline,
              hrvToday > 0, hrvBaseline > 0, rhrToday > 0, rhrBaseline > 0,
              sleep > 0, goal > 0 else { return nil }
        let sleepPart = min(sleep / goal, 1) * 50
        let hrvPart = min(hrvToday / hrvBaseline, 1) * 25
        let heartPart = min(rhrBaseline / rhrToday, 1) * 25
        return Int((sleepPart + hrvPart + heartPart).rounded())
    }
}
