struct Vital: Equatable {
    var today: Double?
    var baseline: Double?

    var isBelowBaseline: Bool {
        guard let today, let baseline else { return false }
        return today < baseline
    }

    var isAboveBaseline: Bool {
        guard let today, let baseline else { return false }
        return today > baseline
    }
}
