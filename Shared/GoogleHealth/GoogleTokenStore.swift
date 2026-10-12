import Foundation
import Security

/// Both targets list the same first keychain access group, so an item saved by the app is readable by the widget.
enum GoogleTokenStore {
    private static let service = "com.prasanthdendukuri.openhealth.googlehealth.session"
    /// Before the widget shared the session, it lived in the app's private keychain group under this service.
    private static let legacyService = "com.prasanthdendukuri.openhealth.googlehealth"

    private static func identity(service: String = service) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "oauth"
        ]
    }

    static func load() -> GoogleTokens? {
        var query = identity()
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        var result: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
              let data = result as? Data else { return nil }
        return try? JSONDecoder().decode(GoogleTokens.self, from: data)
    }

    static func save(_ tokens: GoogleTokens) throws {
        let data = try JSONEncoder().encode(tokens)
        let updated = SecItemUpdate(identity() as CFDictionary, [kSecValueData as String: data] as CFDictionary)
        if updated == errSecSuccess { return }
        guard updated == errSecItemNotFound else { throw keychainError(updated) }

        var item = identity()
        item[kSecValueData as String] = data
        item[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        let created = SecItemAdd(item as CFDictionary, nil)
        guard created == errSecSuccess else { throw keychainError(created) }
    }

    static func delete() {
        SecItemDelete(identity() as CFDictionary)
        SecItemDelete(identity(service: legacyService) as CFDictionary)
    }

    private static func keychainError(_ status: OSStatus) -> GoogleHealthError {
        GoogleHealthError("Could not save Google session in the iPhone Keychain (\(status)).")
    }
}
