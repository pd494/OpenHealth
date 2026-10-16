import Foundation

/// Launch arguments for screenshots and manual testing, e.g. `-editMode 1 -resetLayout 1`.
/// Release builds ignore all of them.
enum DebugLaunch {
    static func flag(_ key: String) -> Bool {
        string(key) != nil
    }

    static func string(_ key: String) -> String? {
        #if DEBUG
        UserDefaults.standard.string(forKey: key)
        #else
        nil
        #endif
    }
}
