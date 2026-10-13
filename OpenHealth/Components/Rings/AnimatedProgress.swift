import SwiftUI

extension EnvironmentValues {
    @Entry var fillDelay = 0.0
}

/// Feeds `content` a ratio that eases up from zero on appear and toward each new value.
/// Kept out of `ProgressRing` so the widget, which shares it, stays static.
struct AnimatedProgress<Content: View>: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.fillDelay) private var fillDelay
    @State private var displayed: Double?

    let ratio: Double
    @ViewBuilder let content: (Double) -> Content

    var body: some View {
        content(displayed ?? (reduceMotion ? ratio : 0))
            .onAppear { fill(delay: fillDelay) }
            .onChange(of: ratio) { fill(delay: 0) }
    }

    private func fill(delay: Double) {
        if reduceMotion {
            displayed = ratio
        } else {
            withAnimation(Motion.fill.delay(delay)) { displayed = ratio }
        }
    }
}
