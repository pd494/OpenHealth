import SwiftUI

struct DemoBanner: View {
    @Binding var sheet: TodaySheet?

    var body: some View {
        Button { sheet = .googleConnection } label: {
            HStack {
                Image(systemName: "sparkles")
                    .accessibilityHidden(true)
                Text("Preview data · Tap to connect your data")
                Spacer()
                Image(systemName: "arrow.up.right")
                    .accessibilityHidden(true)
            }
            .font(.caption.weight(.medium))
            .foregroundStyle(Color.secondary)
        }
    }
}
