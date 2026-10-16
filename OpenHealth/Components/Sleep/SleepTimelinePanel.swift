import SwiftUI

struct SleepTimelinePanel: View {
    let night: SleepNight
    @Binding var scrubbed: SleepSegment?

    var body: some View {
        VStack(spacing: 12) {
            SleepTimelineChart(night: night, scrubbed: $scrubbed)
                // The lane names sit inside the drawing, so past this size they'd cover the blocks they label.
                .dynamicTypeSize(...DynamicTypeSize.xLarge)
            axis
            SleepLegend()
        }
    }

    /// The middle tick is the true midpoint of the night, so it stays centred whatever the end labels' widths.
    private var axis: some View {
        let midpoint = night.date(atMinute: night.inBedMinutes / 2)
        return Text(SleepNight.tick(midpoint))
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) { Text(SleepNight.tick(night.bedtime)) }
            .overlay(alignment: .trailing) { Text(SleepNight.tick(night.wake)) }
            .font(.caption)
            .foregroundStyle(.secondary)
            .accessibilityHidden(true)
    }
}
