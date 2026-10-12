enum CaloriePreference: String, Codable, CaseIterable, Identifiable {
    case active
    case total

    var id: String { rawValue }
    var title: String { self == .active ? "Active" : "Total" }
    var metric: MetricID { self == .active ? .activeEnergy : .totalEnergy }
}
