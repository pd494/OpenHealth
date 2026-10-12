import SwiftUI

extension View {
    /// Light impact on pickup and drop, a selection tick each time the lifted item crosses into a new slot.
    func reorderHaptics<ID: Hashable>(lifted: ID?, slot: Int?) -> some View {
        sensoryFeedback(.impact(weight: .light), trigger: lifted)
            .sensoryFeedback(trigger: slot) { old, new in
                old != nil && new != nil ? .selection : nil
            }
    }
}
