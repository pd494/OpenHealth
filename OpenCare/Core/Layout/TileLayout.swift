enum TileLayout: String, Codable, CaseIterable, Identifiable {
    case grid
    case list

    var id: String { rawValue }
    var title: String { self == .grid ? "Grid" : "List" }
    var columns: Int { self == .grid ? 2 : 1 }
}
