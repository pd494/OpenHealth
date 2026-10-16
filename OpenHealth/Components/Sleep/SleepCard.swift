import SwiftUI

/// Last night at a glance: the score, a scrubbable stage timeline, and the time in each stage.
struct SleepCard: View {
    let night: SleepNight
    @State private var scrubbed: SleepSegment?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SleepHeader(night: night)
            SleepTimelinePanel(night: night, scrubbed: $scrubbed)
            StageTiles(night: night)
            SleepScrubReadout(night: night, segment: scrubbed)
        }
        .padding(Layout.cardPadding)
        .surface()
        .sensoryFeedback(.selection, trigger: scrubbed?.id)
    }
}

#Preview {
    SleepCard(night: .demo)
        .padding()
        .background(Palette.background)
}
