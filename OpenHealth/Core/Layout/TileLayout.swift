enum TileLayout: String, Codable, CaseIterable, Identifiable {
    case pills
    case grid
    case list

    var id: String { rawValue }

    var title: String {
        switch self {
        case .pills: "Pills"
        case .grid: "Grid"
        case .list: "List"
        }
    }

    var columns: Int { self == .list ? 1 : 2 }
}
