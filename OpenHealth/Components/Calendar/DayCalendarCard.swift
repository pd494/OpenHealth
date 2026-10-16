import SwiftUI

struct DayCalendarCard: View {
    @Environment(\.dynamicTypeSize) private var typeSize

    let entries: [DayEntry]

    @State private var selection = Calendar.current.startOfDay(for: .now)
    @ScaledMetric(relativeTo: .body) private var timelineHeight = 336.0

    private var headerLayout: AnyLayout {
        typeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: 8))
            : AnyLayout(HStackLayout(spacing: 8))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            headerLayout {
                Text("Your day")
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)
                if !typeSize.isAccessibilitySize { Spacer(minLength: 8) }
                Text("Today")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            WeekStrip(selection: $selection)
            DayTimeline(entries: entries)
                .frame(height: timelineHeight)
        }
        .padding(Layout.cardPadding)
        .surface()
    }
}

#Preview {
    DayCalendarCard(entries: DayEntry.today)
        .padding()
        .pageBackground()
}

#Preview("XXL") {
    DayCalendarCard(entries: DayEntry.today)
        .environment(\.dynamicTypeSize, .xxLarge)
        .padding()
        .pageBackground()
}
