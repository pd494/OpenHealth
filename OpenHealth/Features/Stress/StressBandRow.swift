import SwiftUI

struct StressBandRow: View {
    let band: StressBand
    let share: Double
    let duration: TimeInterval

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(band.title).font(.subheadline.weight(.medium))
                Spacer()
                Text(share, format: .percent.precision(.fractionLength(0)))
                    .metricNumber(.subheadline)
                Text(Duration.seconds(duration).formatted(.units(allowed: [.hours, .minutes], width: .narrow)))
                    .font(.footnote.monospacedDigit())
                    .foregroundStyle(.secondary)
                    .frame(minWidth: 70, alignment: .trailing)
            }
            ProgressBar(ratio: share, tint: band.color)
        }
        .accessibilityElement(children: .combine)
    }
}
