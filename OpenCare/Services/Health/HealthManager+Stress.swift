import Foundation

extension HealthManager {
    func refreshStress() async {
        let end = Date.now
        let hourStart = Calendar.current.dateInterval(of: .hour, for: end)?.start ?? end
        let start = hourStart.adding(-7, .day)
        async let heartRate = reader.hourlyAverages(HealthTypes.heartRate, unit: .beatsPerMinute, from: start, to: end)
        async let variability = reader.hourlyAverages(HealthTypes.hrv, unit: .milliseconds, from: start, to: end)
        let hrvSamples = await variability
        let baseline = hrv.baseline ?? Recovery.baseline(of: hrvSamples.map(\.value))
        guard let baseline, let resting = rhr.today ?? rhr.baseline else {
            stressDay = nil
            return
        }
        let points = StressSampler.points(
            heartRate: await heartRate, hrv: hrvSamples, hrvBaseline: baseline, restingHR: resting
        )
        let dayStart = end.adding(-24, .hour)
        stressDay = StressDay(
            points: points.filter { $0.date >= dayStart },
            interval: 3600,
            sleepWindow: nil,
            week: StressSampler.dailyAverages(points)
        )
        readings[.stress] = stressDay?.current?.score
    }
}
