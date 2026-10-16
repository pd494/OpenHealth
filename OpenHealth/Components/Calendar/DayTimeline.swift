import SwiftUI

struct DayTimeline: View {
    let entries: [DayEntry]

    private static let firstHour = 6
    private static let lastHour = 23
    private static let gutterWidth = 48.0
    private static let entryInset = 56.0

    @ScaledMetric(relativeTo: .caption) private var hourHeight = 56.0

    private var dayStart: Date { Calendar.current.startOfDay(for: .now) }
    private var timelineHeight: Double { Double(Self.lastHour - Self.firstHour + 1) * hourHeight }

    var body: some View {
        ScrollView(.vertical) {
            ZStack(alignment: .topLeading) {
                ForEach(Self.firstHour...Self.lastHour, id: \.self) { hour in
                    HStack(alignment: .top, spacing: 8) {
                        Text(Calendar.current.date(byAdding: .hour, value: hour, to: dayStart)!, format: .dateTime.hour())
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .frame(width: Self.gutterWidth, alignment: .leading)
                        Hairline(axis: .horizontal)
                    }
                    .offset(y: Double(hour - Self.firstHour) * hourHeight)
                    .accessibilityHidden(true)
                }
                ForEach(entries) { entry in
                    DayEntryBlock(entry: entry, hourHeight: hourHeight)
                        .padding(.leading, Self.entryInset)
                        .offset(y: offset(for: entry.startMinute))
                }
                nowLine
                    .offset(y: offset(for: DayEntry.sampleNow))
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .frame(height: timelineHeight, alignment: .topLeading)
        }
        .accessibilityElement(children: .contain)
    }

    private var nowLine: some View {
        HStack(spacing: 0) {
            Text("2:20p")
                .font(.caption2.bold())
                .foregroundStyle(.white)
                .padding(4)
                .background(Palette.red, in: .rect(cornerRadius: 4))
            Rectangle()
                .fill(Palette.red)
                .frame(height: 2)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Now, 2:20 PM")
    }

    private func offset(for minute: Int) -> Double {
        Double(minute - Self.firstHour * 60) / 60 * hourHeight
    }
}

#Preview {
    DayTimeline(entries: DayEntry.today)
        .frame(height: 336)
        .padding()
}
