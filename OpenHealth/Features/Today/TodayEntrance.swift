import SwiftUI

/// First-launch entrance for the Today screen; later appearances render in place.
private struct TodayEntrance: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var shown = Self.played

    @MainActor private static var played = false
    private static let stagger = 0.1

    let index: Int

    func body(content: Content) -> some View {
        content
            .opacity(shown ? 1 : 0)
            .blur(radius: shown || reduceMotion ? 0 : SoftLift.blur)
            .offset(y: shown || reduceMotion ? 0 : SoftLift.rise)
            .onAppear(perform: enter)
    }

    private func enter() {
        guard !shown else { return }
        withAnimation(Motion.resolve(Motion.enter, reduceMotion: reduceMotion).delay(Double(index) * Self.stagger)) {
            shown = true
        }
        Self.played = true
    }
}

extension View {
    func todayEntrance(_ index: Int) -> some View {
        modifier(TodayEntrance(index: index))
    }
}
