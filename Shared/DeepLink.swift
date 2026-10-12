import Foundation

enum DeepLink: String {
    case steps
    case water

    var url: URL { URL(string: "openhealth://\(rawValue)")! }

    init?(url: URL) {
        guard url.scheme == "openhealth", let host = url.host, let link = Self(rawValue: host) else { return nil }
        self = link
    }
}
