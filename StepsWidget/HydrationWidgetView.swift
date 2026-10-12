import SwiftUI

struct HydrationWidgetView: View {
    let snapshot: SharedSnapshot

    private var updateText: Text {
        if snapshot.waterCheckedAt == .distantPast {
            Text("Open app to log water")
        } else {
            Text("Checked \(snapshot.waterCheckedAt, format: .dateTime.hour().minute())")
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("HYDRATION", systemImage: "drop.fill")
                .font(.caption2.bold())
                .tracking(1.3)
                .foregroundStyle(.white.opacity(0.7))
            Spacer(minLength: 0)
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 1) {
                    Text("\(Int(snapshot.waterOunces.rounded())) oz")
                        .font(.rounded(size: 30, weight: .bold))
                        .minimumScaleFactor(0.65)
                        .lineLimit(1)
                    Text("of \(Int(snapshot.waterGoal)) oz")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.65))
                }
                Spacer(minLength: 2)
                ProgressRing(ratio: snapshot.waterProgress, lineWidth: 7).frame(width: 42, height: 42)
            }
            WidgetFootnote(text: updateText)
        }
        .widgetStyle(opening: .water)
    }
}
