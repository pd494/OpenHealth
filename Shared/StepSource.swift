/// Raw values are persisted, so don't rename cases.
enum StepSource: String {
    case apple
    case google
    case demo

    var displayName: String {
        switch self {
        case .apple: "Apple Health"
        case .google: "Google Health"
        case .demo: "Preview"
        }
    }
}
