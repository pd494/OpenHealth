import Foundation

/// Launch arguments for screenshots and manual testing, e.g. `-tab sleep -ringsMode expanded`.
/// Release builds ignore all of them.
enum DebugLaunch {
    static func string(_ key: String) -> String? {
        #if DEBUG
        UserDefaults.standard.string(forKey: key)
        #else
        nil
        #endif
    }

    static func flag(_ key: String) -> Bool { string(key) != nil }

    static var tab: AppTab? { string("tab").flatMap(AppTab.init) }

    static func apply(to layout: inout DashboardLayout) {
        if flag("resetLayout") { layout = .default }
        if let value = string("tileLayout").flatMap(TileLayout.init) { layout.tileLayout = value }
        if let value = string("ringsMode").flatMap(RingsMode.init) { layout.ringsMode = value }
        if flag("collapsed") { layout.ringDetailsCollapsed = true }
        if let value = string("calories").flatMap(CaloriePreference.init) { layout.calories = value }
    }
}
