import Foundation

/// `nil` until Info.plist holds a real client ID instead of the CONFIGURE placeholder.
struct GoogleOAuthConfig {
    let clientID: String
    let scheme: String

    var redirectURI: String { "\(scheme):/oauth2redirect" }

    init?(bundle: Bundle = .main) {
        guard let clientID = bundle.object(forInfoDictionaryKey: "GoogleHealthClientID") as? String,
              let scheme = bundle.object(forInfoDictionaryKey: "GoogleHealthRedirectScheme") as? String,
              !clientID.contains("CONFIGURE"), !scheme.contains("CONFIGURE") else { return nil }
        self.clientID = clientID
        self.scheme = scheme
    }
}
