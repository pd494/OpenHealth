import SwiftUI

extension View {
    /// Impact on pickup and drop, a selection tick each time the lifted item crosses into a new slot.
    func reorderHaptics<ID: Hashable>(lifted: ID?, slot: Int?) -> some View {
        sensoryFeedback(.impact(weight: .medium), trigger: lifted)
            .sensoryFeedback(trigger: slot) { old, new in
                old != nil && new != nil ? .selection : nil
            }
    }
}
