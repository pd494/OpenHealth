enum RingsMode: String, Codable, CaseIterable, Identifiable {
    case standard
    case expanded
    case beside

    var id: String { rawValue }

    var title: String {
        switch self {
        case .standard: "Standard"
        case .expanded: "Expanded"
        case .beside: "Beside"
        }
    }
}
