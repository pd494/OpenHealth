import Foundation

enum GoogleTokenEndpoint {
    private static let url = URL(string: "https://oauth2.googleapis.com/token")!

    static func exchange(code: String, verifier: String, clientID: String, redirectURI: String) async throws -> GoogleTokens {
        try await request([
            "client_id": clientID,
            "code": code,
            "code_verifier": verifier,
            "redirect_uri": redirectURI,
            "grant_type": "authorization_code"
        ], clientID: clientID, keeping: nil)
    }

    static func refresh(_ tokens: GoogleTokens) async throws -> GoogleTokens {
        guard let refreshToken = tokens.refreshToken else {
            throw GoogleHealthError("Google session expired. Reconnect your account.")
        }
        return try await request([
            "client_id": tokens.clientID,
            "refresh_token": refreshToken,
            "grant_type": "refresh_token"
        ], clientID: tokens.clientID, keeping: refreshToken)
    }

    /// Google omits the refresh token on refresh responses, so the existing one is kept.
    private static func request(_ fields: [String: String], clientID: String, keeping refreshToken: String?) async throws -> GoogleTokens {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 15
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        var body = URLComponents()
        body.queryItems = fields.map { URLQueryItem(name: $0.key, value: $0.value) }
        request.httpBody = body.percentEncodedQuery?.data(using: .utf8)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw GoogleHealthError("No response from Google sign-in.") }
        guard (200..<300).contains(http.statusCode) else {
            let detail = try? JSONDecoder().decode(ErrorResponse.self, from: data).message
            throw GoogleHealthError(detail ?? "Google token request failed (\(http.statusCode)).")
        }
        let payload = try JSONDecoder().decode(TokenResponse.self, from: data)
        return GoogleTokens(
            accessToken: payload.accessToken,
            refreshToken: payload.refreshToken ?? refreshToken,
            expiry: Date.now.addingTimeInterval(TimeInterval(payload.expiresIn)),
            clientID: clientID
        )
    }

    private struct ErrorResponse: Decodable {
        let error: String?
        let errorDescription: String?

        var message: String? { errorDescription ?? error }

        enum CodingKeys: String, CodingKey {
            case error
            case errorDescription = "error_description"
        }
    }

    private struct TokenResponse: Decodable {
        let accessToken: String
        let refreshToken: String?
        let expiresIn: Int

        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case refreshToken = "refresh_token"
            case expiresIn = "expires_in"
        }
    }
}
