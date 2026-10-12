import SwiftUI

struct ReorderActions {
    var lift: (AnyHashable) -> Void = { _ in }
    var drag: (AnyHashable, CGPoint, CGPoint) -> Void = { _, _, _ in }
    var drop: () -> Void = {}
}

extension EnvironmentValues {
    @Entry var reorderActions = ReorderActions()
}

enum ReorderSpace {
    static let name = "reorderGrid"
}
