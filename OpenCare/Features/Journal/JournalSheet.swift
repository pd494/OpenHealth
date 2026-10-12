import SwiftData

enum JournalSheet: Identifiable {
    case new
    case edit(JournalEntry)

    var id: String {
        switch self {
        case .new: "new"
        case .edit(let entry): "\(entry.persistentModelID)"
        }
    }
}
