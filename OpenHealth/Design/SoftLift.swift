import SwiftUI

struct SoftLift: Transition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .opacity(phase.isIdentity ? 1 : 0)
            .blur(radius: phase.isIdentity ? 0 : SoftLift.blur)
            .offset(y: phase.isIdentity ? 0 : phase == .willAppear ? SoftLift.rise : -SoftLift.rise)
    }

    static let blur = 4.0
    static let rise = 12.0
}

extension View {
    func softLift() -> some View {
        modifier(SoftLiftModifier())
    }
}

private struct SoftLiftModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content.transition(reduceMotion ? AnyTransition.opacity : AnyTransition(SoftLift()))
    }
}
