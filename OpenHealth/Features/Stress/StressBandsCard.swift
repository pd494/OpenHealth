import SwiftUI

struct StressBandsCard: View {
    let day: StressDay

    private var summary: String {
        let high = day.duration(of: .high)
        guard high > 0 else { return "No high stress today" }
        return "\(Duration.seconds(high).formatted(.units(allowed: [.hours, .minutes], width: .narrow))) in high stress today"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(summary).font(.rounded(.title3, weight: .semibold))
            ForEach(StressBand.allCases) { band in
                StressBandRow(band: band, share: day.share(of: band), duration: day.duration(of: band))
            }
        }
        .card()
    }
}
