import SwiftUI
import WidgetKit

struct OpenHealthStepsWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: WidgetKind.steps, provider: SnapshotProvider()) { entry in
            StepsWidgetView(snapshot: entry.snapshot)
        }
        .configurationDisplayName("OpenHealth Steps")
        .description("Your steps and goal on the Home Screen.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview("Small", as: .systemSmall) {
    OpenHealthStepsWidget()
} timeline: {
    SnapshotEntry(date: .now, snapshot: .sample)
}

#Preview("Medium", as: .systemMedium) {
    OpenHealthStepsWidget()
} timeline: {
    SnapshotEntry(date: .now, snapshot: .sample)
}
