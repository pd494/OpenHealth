import SwiftUI

struct AskCard: View {
    @Binding var sheet: TodaySheet?

    var body: some View {
        Button { sheet = .insights } label: {
            HStack(spacing: 14) {
                Image(systemName: "sparkle.magnifyingglass")
                    .font(.title2)
                    .foregroundStyle(Palette.purple)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 3) {
                    Text("Ask OpenHealth")
                        .font(.headline)
                        .foregroundStyle(Color.primary)
                    Text("Ask about your steps, sleep or recovery")
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.secondary)
                    .accessibilityHidden(true)
            }
            .card()
        }
    }
}
