import SwiftUI
import WidgetKit

struct OpenCareStepsWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: WidgetKind.steps, provider: SnapshotProvider()) { entry in
            StepsWidgetView(snapshot: entry.snapshot)
        }
        .configurationDisplayName("OpenCare Steps")
        .description("Your steps and goal on the Home Screen.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview("Small", as: .systemSmall) {
    OpenCareStepsWidget()
} timeline: {
    SnapshotEntry(date: .now, snapshot: .sample)
}

#Preview("Medium", as: .systemMedium) {
    OpenCareStepsWidget()
} timeline: {
    SnapshotEntry(date: .now, snapshot: .sample)
}
