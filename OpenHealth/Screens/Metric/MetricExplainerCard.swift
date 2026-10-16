import SwiftUI

struct MetricExplainerCard: View {
    let domain: MetricDomain

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("What it means")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .accessibilityAddTraits(.isHeader)
            Text(domain.explanation)
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Layout.cardPadding)
        .surface()
    }
}

#Preview {
    MetricExplainerCard(domain: .vitals).padding().pageBackground()
}
