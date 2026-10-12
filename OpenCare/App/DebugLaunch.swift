#if DEBUG
import Foundation

/// Launch arguments for screenshots and manual testing, e.g. `-tileLayout list -calories total`.
enum DebugLaunch {
    static func string(_ key: String) -> String? { UserDefaults.standard.string(forKey: key) }

    static func apply(to layout: inout DashboardLayout) {
        if let value = string("tileLayout").flatMap(TileLayout.init) { layout.tileLayout = value }
        if let value = string("calories").flatMap(CaloriePreference.init) { layout.calories = value }
    }
}
#endif
