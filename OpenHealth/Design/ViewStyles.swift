import SwiftUI

extension View {
    func card(radius: Double = Layout.cardRadius) -> some View {
        padding(Layout.cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .surface(radius: radius)
    }

    /// A raised card: a faint top-lit sheen, a light-catching top edge and a soft drop shadow,
    /// so cards read as objects above the background rather than outlines on it.
    func surface(radius: Double = Layout.cardRadius) -> some View {
        let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)
        return background {
            shape
                .fill(Palette.card)
                .overlay { shape.fill(Palette.sheen) }
                .shadow(color: .black.opacity(0.35), radius: 12, y: 6)
        }
        .overlay { shape.strokeBorder(Palette.rim, lineWidth: 0.75) }
    }

    /// Floating control background: Liquid Glass where available, a raised material otherwise.
    @ViewBuilder func chrome<S: Shape>(in shape: S) -> some View {
        if #available(iOS 26, *) {
            glassEffect(.regular.interactive(), in: shape)
        } else {
            background(.ultraThinMaterial, in: shape)
                .overlay { shape.stroke(Palette.rim, lineWidth: 0.75) }
        }
    }

    func dashedSurface(radius: Double = Layout.cardRadius) -> some View {
        overlay {
            RoundedRectangle(cornerRadius: radius)
                .strokeBorder(Palette.stitch, style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
        }
    }

    func inputSurface(radius: Double = Layout.cardRadius) -> some View {
        background(.white.opacity(0.08), in: .rect(cornerRadius: radius))
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
