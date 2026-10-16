import SwiftUI

struct IntensityCard: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    @Binding var intensity: Double

    private var level: IntensityLevel { IntensityLevel(intensity: intensity) }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            let layout = typeSize.isAccessibilitySize ? AnyLayout(VStackLayout(alignment: .leading, spacing: 8)) : AnyLayout(HStackLayout(spacing: 8))
            layout {
                Text("How hard was it?").font(.subheadline.bold())
                Spacer(minLength: 0)
                Text(level.rawValue).font(.subheadline).foregroundStyle(.secondary)
            }
            Text(level.description).font(.footnote).foregroundStyle(.secondary)
            Slider(value: $intensity, in: 1...10, step: 1) {
                Text("Intensity")
            }
            .tint(.clear)
            .background {
                LinearGradient(colors: [Color(red: 0.78, green: 0.84, blue: 1), .yellow, .orange, .red], startPoint: .leading, endPoint: .trailing)
                    .frame(height: 10)
                    .clipShape(.capsule)
                    .padding(.horizontal, 4)
                    .accessibilityHidden(true)
            }
            .accessibilityValue(level.rawValue)
            HStack {
                Text("Easy")
                Spacer()
                Text("All out")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            .accessibilityHidden(true)
        }
        .padding(Layout.cardPadding)
        .surface()
    }
}

#Preview { IntensityCard(intensity: .constant(5)).padding() }
