import SwiftUI

struct MetricDetailView: View {
    let metric: MetricID

    @State private var range: MetricRange = .month

    private var series: MetricSeries { MetricSeries(metric: metric, range: range) }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                MetricSummaryCard(metric: metric, series: series, range: $range)
                MetricExplainerCard(domain: metric.descriptor.domain)
                RecentValuesCard(metric: metric, series: MetricSeries(metric: metric, range: .week))
            }
            .padding(Layout.screenPadding)
        }
        .pageBackground()
        .navigationTitle(metric.descriptor.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { MetricDetailView(metric: .restingHeartRate) }
}
