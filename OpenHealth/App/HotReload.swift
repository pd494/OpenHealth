import Inject
import SwiftUI

extension View {
    /// Debug only: rebuilds this view's whole subtree after every hot reload, so edits to any
    /// child component show up without marking each one with `@ObserveInjection`.
    /// Rebuilding resets `@State` below this point (scroll position, edit mode).
    func reloadsOnInjection() -> some View {
        #if DEBUG
        modifier(InjectionReloader())
        #else
        self
        #endif
    }
}

#if DEBUG
private struct InjectionReloader: ViewModifier {
    @State private var generation = 0

    func body(content: Content) -> some View {
        content
            .id(generation)
            .onReceive(InjectConfiguration.observer.objectWillChange) { generation += 1 }
            .enableInjection()
    }
}
#endif
