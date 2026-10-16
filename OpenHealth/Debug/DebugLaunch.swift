import SwiftUI

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

extension View {
    /// Debug only: `-scrollEnd 1` opens a scroll view at its bottom, so a screenshot can show what's below the fold.
    func debugScrollAnchor() -> some View {
        defaultScrollAnchor(DebugLaunch.flag("scrollEnd") ? .bottom : .top)
    }
}
