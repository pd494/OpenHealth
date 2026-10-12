import Foundation

enum SnapshotStore {
    static let groupID = "group.com.prasanthdendukuri.openhealth"
    private static let key = "dailyStepsSnapshot"

    static func load() -> SharedSnapshot {
        guard let data = UserDefaults(suiteName: groupID)?.data(forKey: key),
              let snapshot = try? JSONDecoder().decode(SharedSnapshot.self, from: data) else {
            return .empty
        }
        guard Calendar.current.isDateInToday(snapshot.updatedAt) else {
            // Yesterday's totals are meaningless today; keep only the user's goals and source.
            var reset = SharedSnapshot.empty
            reset.stepGoal = snapshot.stepGoal
            reset.waterGoal = snapshot.waterGoal
            reset.sourceName = snapshot.sourceName
            return reset
        }
        return snapshot
    }

    static func save(_ snapshot: SharedSnapshot) {
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        UserDefaults(suiteName: groupID)?.set(data, forKey: key)
    }
}
