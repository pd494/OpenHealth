import SwiftUI
import WidgetKit

struct StepsWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let snapshot: SharedSnapshot

    private var updateText: Text {
        if snapshot.isFromGoogle, let synced = snapshot.deviceSyncedAt {
            Text("Air synced \(synced, format: .dateTime.hour().minute())")
        } else if snapshot.stepsCheckedAt == .distantPast {
            Text("Open app to connect")
        } else {
            Text("Checked \(snapshot.stepsCheckedAt, format: .dateTime.hour().minute())")
        }
    }

    var body: some View {
        Group {
            if family == .systemSmall { small } else { medium }
        }
        .widgetStyle(opening: .steps)
    }

    private var small: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("STEPS", systemImage: "figure.walk")
                .font(.caption2.bold())
                .tracking(1.4)
                .foregroundStyle(.white.opacity(0.7))
            Spacer(minLength: 0)
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 1) {
                    Text(snapshot.steps, format: .number)
                        .font(.rounded(size: 32, weight: .bold))
                        .minimumScaleFactor(0.65)
                        .lineLimit(1)
                    Text("of \(snapshot.stepGoal, format: .number)")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.65))
                }
                Spacer(minLength: 2)
                ProgressRing(ratio: snapshot.stepsProgress).frame(width: 42, height: 42)
            }
            WidgetFootnote(text: updateText)
        }
    }

    private var medium: some View {
        HStack(spacing: 18) {
            ProgressRing(ratio: snapshot.stepsProgress).frame(width: 92, height: 92)
            VStack(alignment: .leading, spacing: 5) {
                Text("STEPS TODAY")
                    .font(.caption.bold())
                    .tracking(1.5)
                    .foregroundStyle(.white.opacity(0.65))
                Text(snapshot.steps, format: .number)
                    .font(.rounded(size: 36, weight: .bold))
                Text("of \(snapshot.stepGoal, format: .number) goal")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
                WidgetFootnote(text: updateText)
            }
            Spacer(minLength: 0)
        }
    }
}
