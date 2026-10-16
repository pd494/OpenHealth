/// Where a logged item came from, shown as a small tag on calendar and workout rows.
enum DataSource {
    case googleHealth
    case manual

    var title: String {
        switch self {
        case .googleHealth: "Google Health"
        case .manual: "Logged"
        }
    }
}
