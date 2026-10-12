import SwiftUI

struct EmptyState: View {
    let title: String
    let message: String
    let systemImage: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.title)
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)
            Text(title).font(.rounded(.headline))
            Text(message)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .dashedSurface()
        .accessibilityElement(children: .combine)
        .softLift()
    }
}
