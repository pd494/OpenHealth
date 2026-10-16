import SwiftUI

struct SleepLegend: View {
    private static let order: [SleepStage] = [.awake, .rem, .core, .deep]

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 12) { swatches }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 96), alignment: .leading)], alignment: .leading, spacing: 8) { swatches }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityHidden(true)
    }

    @ViewBuilder private var swatches: some View {
        ForEach(Self.order, id: \.self) { stage in
            HStack(spacing: 4) {
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(stage.fill)
                    .frame(width: 8, height: 8)
                Text(stage.title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize()
            }
        }
    }
}
