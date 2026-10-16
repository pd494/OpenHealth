import SwiftUI

struct SleepView: View {
    private static let ranges = ["Last night", "Last 7 nights", "Last 30 nights"]

    private let night = SleepNight.demo

    @State private var range = Self.ranges[0]
    @State private var scrubbed: SleepSegment?

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                SleepHero(night: night)
                VStack(spacing: 16) {
                    SleepTimelinePanel(night: night, scrubbed: $scrubbed)
                    StageTiles(night: night)
                    SleepScrubReadout(night: night, segment: scrubbed)
                }
                .padding(Layout.cardPadding)
                .surface()
                .sensoryFeedback(.selection, trigger: scrubbed?.id)
                BedtimeWindowCard()
                SleepStatPair()
            }
            .padding(.horizontal, Layout.screenPadding)
            .padding(.bottom, 24)
        }
        .debugScrollAnchor()
        .pageBackground()
        .navigationTitle("Sleep")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) { rangeMenu }
        }
    }

    private var rangeMenu: some View {
        Menu {
            Picker("Range", selection: $range) {
                ForEach(Self.ranges, id: \.self) { Text($0) }
            }
        } label: {
            HStack(spacing: 4) {
                Text(range)
                Image(systemName: "chevron.down")
                    .font(.caption.weight(.semibold))
                    .accessibilityHidden(true)
            }
        }
    }
}

#Preview {
    NavigationStack { SleepView() }
}
