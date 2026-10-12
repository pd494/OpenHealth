import SwiftUI

extension View {
    func card(radius: Double = Layout.cardRadius) -> some View {
        padding(Layout.cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .surface(radius: radius)
    }

    /// Raised card: a top-lit rim and a two-layer shadow (tight contact + soft ambient)
    /// so it sits above the page instead of being printed on it.
    func surface(radius: Double = Layout.cardRadius, tint: Color = .clear) -> some View {
        modifier(Surface(radius: radius, tint: tint))
    }

    /// Screen backdrop: the grouped background plus an ambient wash so raised cards have something to sit above.
    func pageBackground(accent: Color = Palette.green) -> some View {
        background {
            ZStack {
                Palette.background
            }
            .ignoresSafeArea()
        }
    }

    func dashedSurface(radius: Double = Layout.cardRadius) -> some View {
        overlay {
            RoundedRectangle(cornerRadius: radius)
                .strokeBorder(Palette.stitch, style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
        }
    }

    func inputSurface(radius: Double = Layout.cardRadius) -> some View {
        background(Color(.tertiarySystemFill), in: .rect(cornerRadius: radius))
    }

    func iconOnlyButton() -> some View {
        labelStyle(.iconOnly).frame(width: Layout.minTapTarget, height: Layout.minTapTarget)
    }

    func errorAlert(_ title: String, message: Binding<String?>) -> some View {
        alert(
            title,
            isPresented: Binding(
                get: { message.wrappedValue != nil },
                set: { if !$0 { message.wrappedValue = nil } }
            )
        ) {} message: {
            Text(message.wrappedValue ?? "")
        }
    }
}

private struct Surface: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    let radius: Double
    let tint: Color

    func body(content: Content) -> some View {
        content.background {
            let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)
            shape
                .fill(Palette.card)
                .overlay {
                    // Tinted washes on black turn muddy, so dark mode keeps the card nearly neutral.
                    shape.fill(
                        RadialGradient(
                            colors: [tint.opacity(colorScheme == .dark ? 0 : 0.06), .clear],
                            center: .topLeading, startRadius: 0, endRadius: 260
                        )
                    )
                }
                .overlay { shape.strokeBorder(Palette.bevel, lineWidth: 1) }
                .shadow(color: Palette.contactShadow, radius: 1.5, y: 1)
                .shadow(color: Palette.ambientShadow, radius: 14, y: 8)
        }
    }
}
