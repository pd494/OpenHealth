import SwiftUI

struct RingsCard: View {
    @Environment(HealthManager.self) private var health
    @Environment(GoogleHealthManager.self) private var google

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            SectionHeader(title: "Your day") {
                if health.isLoading || google.isSyncing { ProgressView().tint(Palette.green) }
            }
            HStack(alignment: .top, spacing: 4) {
                MetricRingView(value: health.value(.steps))
                MetricRingView(value: health.value(.recovery))
                MetricRingView(value: health.value(.sleep))
            }
        }
        .card(radius: 28)
    }
}
