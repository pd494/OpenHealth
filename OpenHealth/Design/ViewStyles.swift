import SwiftUI

extension View {
    func card(radius: Double = Layout.cardRadius) -> some View {
        padding(Layout.cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .surface(radius: radius)
    }

    func surface(radius: Double = Layout.cardRadius) -> some View {
        background(Palette.card, in: .rect(cornerRadius: radius))
            .overlay { RoundedRectangle(cornerRadius: radius).strokeBorder(Palette.hairline, lineWidth: 0.5) }
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
