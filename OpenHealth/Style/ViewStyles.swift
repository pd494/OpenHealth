import SwiftUI

extension View {
    /// Raised card: a top-lit rim and a two-layer shadow (tight contact + soft ambient)
    /// so it sits above the page instead of being printed on it.
    func surface(radius: Double = Layout.cardRadius) -> some View {
        modifier(Surface(radius: radius))
    }

    func pageBackground() -> some View {
        background(Palette.background.ignoresSafeArea())
    }

    func dashedSurface(radius: Double = Layout.cardRadius) -> some View {
        overlay {
            RoundedRectangle(cornerRadius: radius)
                .strokeBorder(Palette.separator, style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
        }
    }
}

private struct Surface: ViewModifier {
    let radius: Double

    func body(content: Content) -> some View {
        content.background {
            let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)
            shape
                .fill(Palette.card)
                .overlay { shape.strokeBorder(Palette.bevel, lineWidth: 1) }
                .shadow(color: Palette.contactShadow, radius: 1.5, y: 1)
                .shadow(color: Palette.ambientShadow, radius: 14, y: 8)
        }
    }
}

struct Hairline: View {
    let axis: Axis

    var body: some View {
        Rectangle()
            .fill(Palette.separator)
            .frame(width: axis == .vertical ? 1 : nil, height: axis == .horizontal ? 1 : nil)
            .accessibilityHidden(true)
    }
}

struct PressableButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var scale = 0.96

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && isEnabled && !reduceMotion ? scale : 1)
            .animation(Motion.press, value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PressableButtonStyle {
    static var pressable: PressableButtonStyle { PressableButtonStyle() }
}
