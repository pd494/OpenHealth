import SwiftUI

struct TodayFooter: View {
    @Environment(HealthManager.self) private var health
    @Environment(GoogleHealthManager.self) private var google

    private var isConnected: Bool { google.isConnected || health.isConnected }

    private var sourceName: String {
        if google.isConnected { return "Google Health" }
        if health.isConnected { return "Apple Health" }
        return "Not connected"
    }

    var body: some View {
        if !health.isDemo {
            VStack(spacing: 14) {
                Hairline()
                statusRow
            }
        }
    }

    private var statusRow: some View {
        HStack(spacing: 7) {
            Circle()
                .fill(isConnected ? Palette.green : Color.secondary)
                .frame(width: 7, height: 7)
            Text(sourceName)
            Spacer()
            if let date = health.lastUpdated {
                Text("Updated \(date, format: .dateTime.hour().minute())")
            }
        }
        .font(.caption)
        .foregroundStyle(.secondary)
    }
}
