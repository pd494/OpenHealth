import SwiftUI
import WidgetKit

struct OpenCareHydrationWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: WidgetKind.hydration, provider: SnapshotProvider()) { entry in
            HydrationWidgetView(snapshot: entry.snapshot)
        }
        .configurationDisplayName("OpenCare Hydration")
        .description("Today's water and your daily goal.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview("Hydration", as: .systemSmall) {
    OpenCareHydrationWidget()
} timeline: {
    SnapshotEntry(date: .now, snapshot: .sample)
}
