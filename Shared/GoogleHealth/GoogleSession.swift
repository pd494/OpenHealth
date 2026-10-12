import Foundation

/// The signed-in Google account, readable by the app and the widget extension alike.
enum GoogleSession {
    static func accessToken() async throws -> String {
        guard var tokens = GoogleTokenStore.load() else { throw GoogleHealthError("Connect Google Health again.") }
        if tokens.expiry <= Date.now.addingTimeInterval(60) {
            tokens = try await GoogleTokenEndpoint.refresh(tokens)
            try GoogleTokenStore.save(tokens)
        }
        return tokens.accessToken
    }
}
