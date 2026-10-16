import SwiftUI

struct SameAsYesterdayCard: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "clock.arrow.circlepath").font(.title3).accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text("Same as yesterday's lunch?").font(.subheadline).bold()
                Text("Chicken bowl · 640 kcal").font(.footnote).foregroundStyle(.secondary)
            }
            .fixedSize(horizontal: false, vertical: true)
            .accessibilityElement(children: .combine)
            Spacer(minLength: 0)
            Button {} label: {
                Label("Add yesterday's lunch", systemImage: "plus").labelStyle(.iconOnly)
                    .frame(minWidth: Layout.minTapTarget, minHeight: Layout.minTapTarget)
                    .background(Palette.card, in: .circle)
            }
        }
        .padding(16)
        .background(MetricDomain.nutrition.ringStart.opacity(0.1), in: .rect(cornerRadius: Layout.cardRadius))
    }
}
#Preview { SameAsYesterdayCard().padding().pageBackground() }
