import SwiftUI

struct LogConfirmButton: View {
    @Environment(\.dismiss) private var dismiss
    let title: String

    var body: some View {
        Button(title) { dismiss() }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(.black, in: .capsule)
            .buttonStyle(.plain)
            .padding(Layout.screenPadding)
            .background(Palette.background)
    }
}

#Preview { LogConfirmButton(title: "Add to log") }
