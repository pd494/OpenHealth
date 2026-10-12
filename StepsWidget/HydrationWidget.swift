import SwiftUI
import WidgetKit

struct OpenHealthHydrationWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: WidgetKind.hydration, provider: SnapshotProvider()) { entry in
            HydrationWidgetView(snapshot: entry.snapshot)
        }
        .configurationDisplayName("OpenHealth Hydration")
        .description("Today's water and your daily goal.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview("Hydration", as: .systemSmall) {
    OpenHealthHydrationWidget()
} timeline: {
    SnapshotEntry(date: .now, snapshot: .sample)
}
