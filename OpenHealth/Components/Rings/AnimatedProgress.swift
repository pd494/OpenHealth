import SwiftUI

extension EnvironmentValues {
    /// False for a copy of an item that's already on screen, like the one following a finger, so it doesn't refill from empty.
    @Entry var fillsOnAppear = true
}

/// Feeds `content` a ratio that eases up from zero on appear and toward each new value.
struct AnimatedProgress<Content: View>: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.fillsOnAppear) private var fillsOnAppear
    @State private var displayed: Double?

    let ratio: Double
    @ViewBuilder let content: (Double) -> Content

    var body: some View {
        content(displayed ?? (isInstant ? ratio : 0))
            .onAppear { fill() }
            .onChange(of: ratio) { fill() }
    }

    private var isInstant: Bool { reduceMotion || !fillsOnAppear }

    private func fill() {
        if isInstant {
            displayed = ratio
        } else {
            withAnimation(Motion.fill) { displayed = ratio }
        }
    }
}
