enum DisplayStyle: String, Codable {
    case tile
    case ring
    /// A pill pinned inside the Goals card, under the rings.
    case pill

    /// Rings need a goal to fill; tiles and pills work for any metric.
    func supports(_ metric: MetricID) -> Bool { self != .ring || metric.descriptor.supportsGoal }
}
