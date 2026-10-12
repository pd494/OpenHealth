import AuthenticationServices
import CryptoKit
import UIKit

@MainActor
final class GoogleOAuth: NSObject, ASWebAuthenticationPresentationContextProviding {
    private static let authURL = URL(string: "https://accounts.google.com/o/oauth2/v2/auth")!
    private static let scopes = [
        "activity_and_fitness", "sleep", "health_metrics_and_measurements", "nutrition", "settings"
    ].map { "https://www.googleapis.com/auth/googlehealth.\($0).readonly" }

    private var session: ASWebAuthenticationSession?

    static func isCancellation(_ error: Error) -> Bool {
        (error as NSError).code == ASWebAuthenticationSessionError.canceledLogin.rawValue
    }

    func signIn(config: GoogleOAuthConfig) async throws -> GoogleTokens {
        let verifier = Self.randomURLSafeString()
        let state = Self.randomURLSafeString()
        let challenge = Data(SHA256.hash(data: Data(verifier.utf8))).base64URLEncodedString()

        var url = URLComponents(url: Self.authURL, resolvingAgainstBaseURL: false)!
        url.queryItems = [
            .init(name: "client_id", value: config.clientID),
            .init(name: "redirect_uri", value: config.redirectURI),
            .init(name: "response_type", value: "code"),
            .init(name: "access_type", value: "offline"),
            .init(name: "prompt", value: "consent"),
            .init(name: "scope", value: Self.scopes.joined(separator: " ")),
            .init(name: "code_challenge", value: challenge),
            .init(name: "code_challenge_method", value: "S256"),
            .init(name: "state", value: state)
        ]
        let callback = try await authorize(url: url.url!, callbackScheme: config.scheme)
        let response = Self.parameters(in: callback)
        guard response["state"] == state else { throw GoogleHealthError("Google sign-in state did not match.") }
        if let error = response["error"] { throw GoogleHealthError("Google sign-in: \(error)") }
        guard let code = response["code"] else { throw GoogleHealthError("Google did not return an authorization code.") }

        return try await GoogleTokenEndpoint.exchange(code: code, verifier: verifier, clientID: config.clientID, redirectURI: config.redirectURI)
    }

    private func authorize(url: URL, callbackScheme: String) async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
            let session = ASWebAuthenticationSession(url: url, callbackURLScheme: callbackScheme) { [weak self] url, error in
                Task { @MainActor in
                    self?.session = nil
                    if let error {
                        continuation.resume(throwing: error)
                    } else if let url {
                        continuation.resume(returning: url)
                    } else {
                        continuation.resume(throwing: GoogleHealthError("Google sign-in returned no callback."))
                    }
                }
            }
            session.presentationContextProvider = self
            session.prefersEphemeralWebBrowserSession = false
            self.session = session
            if !session.start() {
                self.session = nil
                continuation.resume(throwing: GoogleHealthError("Could not open Google sign-in."))
            }
        }
    }

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow) ?? UIWindow()
    }

    /// The first value wins when a name repeats across query and fragment.
    private static func parameters(in callback: URL) -> [String: String] {
        let parts = URLComponents(url: callback, resolvingAgainstBaseURL: false)
        let fragmentItems = parts?.fragment.flatMap { URLComponents(string: "?" + $0)?.queryItems } ?? []
        let items = (parts?.queryItems ?? []) + fragmentItems
        return Dictionary(items.map { ($0.name, $0.value ?? "") }, uniquingKeysWith: { first, _ in first })
    }

    private static func randomURLSafeString() -> String {
        var bytes = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        return Data(bytes).base64URLEncodedString()
    }
}

private extension Data {
    func base64URLEncodedString() -> String {
        base64EncodedString()
            .replacing("+", with: "-")
            .replacing("/", with: "_")
            .replacing("=", with: "")
    }
}
