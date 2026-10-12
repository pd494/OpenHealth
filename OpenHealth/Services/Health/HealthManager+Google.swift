import HealthKit

extension HealthManager {
    func applyGoogleData(
        steps newSteps: Int,
        sleep: Double?,
        recovery: Int?,
        hrv newHRV: Vital = Vital(),
        rhr newRHR: Vital = Vital(),
        deviceSyncedAt: Date? = nil
    ) {
        isDemo = false
        use(.google)
        steps = newSteps
        stepsCheckedAt = .now
        sleepHours = sleep ?? 0
        recoveryScore = recovery
        hrv = newHRV
        rhr = newRHR
        self.deviceSyncedAt = deviceSyncedAt
        let google = GoogleMetricSource(
            steps: newSteps, sleepHours: sleep, recovery: recovery, hrv: newHRV.today, restingHR: newRHR.today
        )
        for id in GoogleMetricSource.ids { readings[id] = nil }
        readings.merge(google.snapshot) { $1 }
        lastUpdated = .now
        publishWidget()
    }

    /// Steps-only update; skips the widget reload when nothing visible changed to save reload budget.
    func applyGoogleSteps(_ newSteps: Int, deviceSyncedAt: Date? = nil) {
        let shouldReload = stepSource != .google || steps != newSteps || stepsCheckedAt == nil
            || (deviceSyncedAt != nil && self.deviceSyncedAt != deviceSyncedAt)
        isDemo = false
        use(.google)
        steps = newSteps
        readings[.steps] = Double(newSteps)
        stepsCheckedAt = .now
        if let deviceSyncedAt { self.deviceSyncedAt = deviceSyncedAt }
        lastUpdated = .now
        publishWidget(reload: shouldReload)
    }

    func googleDisconnected() async {
        use(.apple)
        if isConnected {
            await refresh()
            return
        }
        readings = [:]
        steps = 0
        sleepHours = 0
        recoveryScore = nil
        hrv = Vital()
        rhr = Vital()
        lastUpdated = .now
        publishWidget()
    }

    func enableGoogleStepWakeups() async {
        guard HKHealthStore.isHealthDataAvailable() else {
            errorMessage = "Apple Health is unavailable on this iPhone."
            return
        }
        do {
            try await store.requestAuthorization(toShare: [], read: [HealthTypes.steps])
            try await store.enableBackgroundDelivery(for: HealthTypes.steps, frequency: .immediate)
            googleStepWakeupsEnabled = true
            Defaults[.googleStepWakeupsEnabled] = true
            startObservers()
            await checkGoogleSharedSteps()
        } catch {
            errorMessage = "Faster step updates could not be enabled: \(error.localizedDescription)"
        }
    }

    func checkGoogleSharedSteps() async {
        guard let total = await reader.googleSharedStepsToday() else {
            googleStepShareDetected = false
            return
        }
        googleStepShareDetected = true
        if let day = Defaults[.googleSharedStepsDay], let previous = Defaults[.googleSharedStepsTotal],
           Calendar.current.isDateInToday(day), abs(total - previous) < 0.5 { return }
        Defaults[.googleSharedStepsDay] = Date.now
        Defaults[.googleSharedStepsTotal] = total
        await GoogleHealthManager.shared.syncStepsOnly()
    }
}
