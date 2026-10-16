import SwiftUI

struct ConnectDataView: View {
    @ScaledMetric private var tileSize = 40.0
    @State private var sleep = true
    @State private var workouts = true
    @State private var nutrition = true
    @State private var heartRate = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Bring your health data")
                        .font(.largeTitle.bold())
                    Text("OpenHealth reads from where your data already lives. Nothing is shared or sold.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                googleHealth
                appleHealth
                Text("You can change this any time in Settings.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding(Layout.screenPadding)
        }
        .pageBackground()
        .navigationBarTitleDisplayMode(.inline)
    }

    private var googleHealth: some View {
        SourceCard(title: "Google Health", detail: "Steps, sleep, heart rate, workouts") {
            Text("G")
                .font(.headline.bold())
                .foregroundStyle(.blue)
                .frame(width: tileSize, height: tileSize)
                .background(.blue.opacity(0.12), in: .circle)
                .accessibilityHidden(true)
        } trailing: {
            Button("Connect") {}
                .font(.subheadline.weight(.semibold))
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .tint(.black)
        } content: {
            EmptyView()
        }
    }

    private var appleHealth: some View {
        SourceCard(title: "Apple Health", detail: "Connected", detailStyle: .green) {
            Image(systemName: "heart.fill")
                .foregroundStyle(.red)
                .frame(width: tileSize, height: tileSize)
                .background(.red.opacity(0.12), in: .circle)
                .accessibilityHidden(true)
        } trailing: {
            EmptyView()
        } content: {
            VStack(spacing: 0) {
                Toggle("Sleep", isOn: $sleep)
                    .frame(minHeight: Layout.minTapTarget)
                Hairline(axis: .horizontal)
                Toggle("Workouts", isOn: $workouts)
                    .frame(minHeight: Layout.minTapTarget)
                Hairline(axis: .horizontal)
                Toggle("Nutrition (write)", isOn: $nutrition)
                    .frame(minHeight: Layout.minTapTarget)
                Hairline(axis: .horizontal)
                Toggle("Heart rate", isOn: $heartRate)
                    .frame(minHeight: Layout.minTapTarget)
            }
        }
    }
}

#Preview {
    NavigationStack { ConnectDataView() }
}
