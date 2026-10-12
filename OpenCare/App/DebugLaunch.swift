#if DEBUG
import Foundation

/// Launch arguments for screenshots and manual testing, e.g. `-tileLayout list -calories total`.
enum DebugLaunch {
    static func string(_ key: String) -> String? { UserDefaults.standard.string(forKey: key) }

    static func flag(_ key: String) -> Bool { string(key) != nil }

    static func apply(to layout: inout DashboardLayout) {
        if string("resetLayout") != nil { layout = .default }
        if let value = string("tileLayout").flatMap(TileLayout.init) { layout.tileLayout = value }
        if let value = string("calories").flatMap(CaloriePreference.init) { layout.calories = value }
    }
}
#else
enum DebugLaunch {
    static func flag(_ key: String) -> Bool { false }
}
#endif
