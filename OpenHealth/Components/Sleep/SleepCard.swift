import SwiftUI

/// Last night at a glance: the score, then a tabbed view of the night's stages, how they compare, and the week.
struct SleepCard: View {
    let night: SleepNight
    @State private var tab = DebugLaunch.string("sleepTab").flatMap(SleepTab.init(debugName:)) ?? .timeline
    @State private var scrubbed: SleepSegment?

    private static let panelHeight = 168.0

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SleepHeader(night: night)
            SleepTabs(selection: $tab)
            panel
                .frame(maxWidth: .infinity, minHeight: Self.panelHeight, alignment: .top)
            StageTiles(night: night)
            footer
        }
        .padding(Layout.cardPadding)
        .surface()
        .sensoryFeedback(.selection, trigger: scrubbed?.id)
    }

    @ViewBuilder private var panel: some View {
        switch tab {
        case .timeline: SleepTimelinePanel(night: night, scrubbed: $scrubbed)
        case .benchmarks: SleepBenchmarks(night: night)
        case .week: SleepWeek(hours: night.weekHours, goal: MetricID.sleep.descriptor.goal)
        }
    }

    @ViewBuilder private var footer: some View {
        if let caption = tab.caption {
            Text(caption)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, minHeight: 20)
        } else {
            SleepScrubReadout(night: night, segment: scrubbed)
        }
    }
}

#Preview {
    SleepCard(night: .demo)
        .padding()
        .background(Palette.background)
}
