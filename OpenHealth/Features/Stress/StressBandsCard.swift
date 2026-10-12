import SwiftUI

struct StressBandsCard: View {
    let day: StressDay

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Duration").eyebrow()
                Text(day.totalDuration.timeString).metricNumber(.title, weight: .bold)
            }
            ForEach(StressBand.allCases) { band in
                StressBandRow(band: band, share: day.share(of: band), duration: day.duration(of: band))
            }
        }
        .card()
    }
}
