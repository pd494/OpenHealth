import HealthKit

struct HealthKitReader {
    let store: HKHealthStore

    func sum(_ type: HKQuantityType, from start: Date, to end: Date, unit: HKUnit) async -> Double {
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        return await statistics(type, predicate, .cumulativeSum)?.sumQuantity()?.doubleValue(for: unit) ?? 0
    }

    func average(_ type: HKQuantityType, from start: Date, to end: Date, unit: HKUnit) async -> Double? {
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end)
        return await statistics(type, predicate, .discreteAverage)?.averageQuantity()?.doubleValue(for: unit)
    }

    func latest(_ type: HKQuantityType, unit: HKUnit) async -> Double? {
        await withCheckedContinuation { continuation in
            let newestFirst = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            store.execute(HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [newestFirst]) { _, samples, _ in
                let sample = samples?.first as? HKQuantitySample
                continuation.resume(returning: sample?.quantity.doubleValue(for: unit))
            })
        }
    }

    func hourlyAverages(_ type: HKQuantityType, unit: HKUnit, from start: Date, to end: Date) async -> [DayValue] {
        await withCheckedContinuation { continuation in
            let query = HKStatisticsCollectionQuery(
                quantityType: type,
                quantitySamplePredicate: HKQuery.predicateForSamples(withStart: start, end: end),
                options: .discreteAverage,
                anchorDate: start,
                intervalComponents: DateComponents(hour: 1)
            )
            query.initialResultsHandler = { _, collection, _ in
                var values: [DayValue] = []
                collection?.enumerateStatistics(from: start, to: end) { statistics, _ in
                    if let average = statistics.averageQuantity() {
                        values.append(DayValue(date: statistics.startDate, value: average.doubleValue(for: unit)))
                    }
                }
                continuation.resume(returning: values)
            }
            store.execute(query)
        }
    }

    /// Detection only: Google's API stays the source of truth for the step total.
    func googleSharedStepsToday() async -> Double? {
        let sources: Set<HKSource> = await withCheckedContinuation { continuation in
            store.execute(HKSourceQuery(sampleType: HealthTypes.steps, samplePredicate: nil) { _, sources, _ in
                continuation.resume(returning: sources ?? [])
            })
        }
        let googleSources = sources.filter {
            let name = $0.name.lowercased(), bundle = $0.bundleIdentifier.lowercased()
            return name.contains("google health") || bundle.contains("googlehealth") || (name + bundle).contains("fitbit")
        }
        guard !googleSources.isEmpty else { return nil }

        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: .now), end: .now, options: .strictStartDate),
            HKQuery.predicateForObjects(from: googleSources)
        ])
        return await statistics(HealthTypes.steps, predicate, .cumulativeSum)?.sumQuantity()?.doubleValue(for: .count())
    }

    /// Hours asleep in the window, merging overlapping samples so two devices don't double count.
    func sleepHours(from start: Date, to end: Date) async -> Double {
        await withCheckedContinuation { continuation in
            let predicate = HKQuery.predicateForSamples(withStart: start, end: end)
            store.execute(HKSampleQuery(sampleType: HealthTypes.sleep, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
                let asleep: Set<Int> = [
                    HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue,
                    HKCategoryValueSleepAnalysis.asleepCore.rawValue,
                    HKCategoryValueSleepAnalysis.asleepDeep.rawValue,
                    HKCategoryValueSleepAnalysis.asleepREM.rawValue
                ]
                let intervals = (samples ?? []).compactMap { $0 as? HKCategorySample }
                    .filter { asleep.contains($0.value) }
                    .map { (start: max(start, $0.startDate), end: min(end, $0.endDate)) }
                    .filter { $0.start < $0.end }
                    .sorted { $0.start < $1.start }
                var merged: [(start: Date, end: Date)] = []
                for interval in intervals {
                    if let last = merged.last, interval.start <= last.end {
                        merged[merged.count - 1].end = max(last.end, interval.end)
                    } else {
                        merged.append(interval)
                    }
                }
                let seconds = merged.reduce(0) { $0 + $1.end.timeIntervalSince($1.start) }
                continuation.resume(returning: seconds / 3600)
            })
        }
    }

    private func statistics(_ type: HKQuantityType, _ predicate: NSPredicate, _ options: HKStatisticsOptions) async -> HKStatistics? {
        await withCheckedContinuation { continuation in
            store.execute(HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: options) { _, result, _ in
                continuation.resume(returning: result)
            })
        }
    }
}
