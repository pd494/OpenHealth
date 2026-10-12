import Foundation

struct WorkoutSummary: Identifiable, Equatable {
    let id: UUID
    let name: String
    let systemImage: String
    let start: Date
    let duration: TimeInterval
    let calories: Double?
    let miles: Double?
}
