import SwiftUI

struct SectionHeader<Trailing: View>: View {
    let title: String
    @ViewBuilder var trailing: Trailing

    var body: some View {
        HStack {
            Text(title)
                .font(.rounded(.headline))
                .accessibilityAddTraits(.isHeader)
            Spacer()
            trailing
        }
    }
}
