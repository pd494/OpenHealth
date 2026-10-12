import Foundation

/// Reads today's steps from Google Health from inside the widget, so it stays current when the app hasn't run.
enum LiveSteps {
    static func refreshed(_ snapshot: SharedSnapshot) async -> SharedSnapshot {
        let api = GoogleHealthAPI()
        guard snapshot.isFromGoogle, let days = try? await api.dailySteps(daysBack: 0) else { return snapshot }
        var fresh = snapshot
        fresh.steps = days.first { Calendar.current.isDateInToday($0.date) }?.count ?? 0
        fresh.stepsCheckedAt = .now
        fresh.updatedAt = .now
        if let air = try? await api.pairedAir() { fresh.deviceSyncedAt = air.lastSync }
        SnapshotStore.save(fresh)
        return fresh
    }
}
