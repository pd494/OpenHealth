import Foundation

enum DeepLink: String {
    case steps
    case water

    var url: URL { URL(string: "opencare://\(rawValue)")! }

    init?(url: URL) {
        guard url.scheme == "opencare", let host = url.host, let link = Self(rawValue: host) else { return nil }
        self = link
    }
}
