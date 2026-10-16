import SwiftUI

struct SourceCard<Tile: View, Trailing: View, Content: View>: View {
    let title: String
    let detail: String
    var detailStyle: Color = .secondary
    @ViewBuilder var tile: Tile
    @ViewBuilder var trailing: Trailing
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ViewThatFits {
                HStack(spacing: 12) {
                    tile
                    labels
                    Spacer(minLength: 0)
                    trailing
                }
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        tile
                        labels
                    }
                    trailing
                }
            }
            content
        }
        .padding(Layout.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .surface()
    }

    private var labels: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            Text(detail)
                .font(.subheadline)
                .foregroundStyle(detailStyle)
        }
    }
}

#Preview {
    SourceCard(title: "Google Health", detail: "Steps, sleep, heart rate, workouts") {
        Text("G")
    } trailing: {
        Button("Connect") {}
    } content: {
        EmptyView()
    }
    .padding()
    .background(Palette.background)
}
