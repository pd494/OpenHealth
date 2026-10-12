import Foundation

struct GoogleTokens: Codable {
    let accessToken: String
    let refreshToken: String?
    let expiry: Date
    /// Stored with the session so the widget can refresh it without app configuration.
    let clientID: String
}
