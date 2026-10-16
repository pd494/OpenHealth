import SwiftUI

struct DayStepper: View {
    var body: some View {
        HStack {
            stepButton("Previous day", symbol: "chevron.left")
            Text("Today, \(Date.now.formatted(.dateTime.month(.abbreviated).day()))")
                .font(.headline)
                .frame(maxWidth: .infinity)
            stepButton("Next day", symbol: "chevron.right")
        }
    }

    private func stepButton(_ label: String, symbol: String) -> some View {
        Button {} label: {
            Image(systemName: symbol)
                .font(.body.weight(.semibold))
                .frame(minWidth: Layout.minTapTarget, minHeight: Layout.minTapTarget)
        }
        .accessibilityLabel(label)
    }
}

#Preview {
    DayStepper().padding()
}
