import SwiftUI

/// The hint under the card, which becomes a readout of the stretch under the finger while scrubbing.
struct SleepScrubReadout: View {
    let night: SleepNight
    let segment: SleepSegment?

    var body: some View {
        Group {
            if let segment {
                HStack(spacing: 6) {
                    Circle().fill(segment.stage.fill).frame(width: 8, height: 8)
                    Text(segment.stage.title).fontWeight(.semibold)
                    Text("\(night.date(atMinute: segment.start), format: .dateTime.hour().minute()) – \(night.date(atMinute: segment.end), format: .dateTime.hour().minute())")
                    Text("· \(SleepNight.duration(segment.minutes))")
                }
            } else {
                Text("Drag across the chart to scrub")
            }
        }
        .font(.footnote)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity, minHeight: 20)
        .accessibilityHidden(true)
    }
}
