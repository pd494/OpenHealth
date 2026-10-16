import SwiftUI

struct StageTiles: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var typeSize

    let night: SleepNight

    private static let order: [SleepStage] = [.deep, .rem, .core, .awake]

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 8), count: typeSize.isAccessibilitySize ? 2 : 4)
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(Self.order, id: \.self) { stage in
                VStack(alignment: .leading, spacing: 8) {
                    Text(SleepNight.duration(night.minutes(in: stage)))
                        .font(.system(.headline, weight: .bold))
                        .foregroundStyle(stage.text(in: colorScheme))
                        .monospacedDigit()
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Text(stage.title)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Palette.sleepWash, in: .rect(cornerRadius: Layout.pillRadius, style: .continuous))
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(stage.title)
                .accessibilityValue(SleepNight.duration(night.minutes(in: stage)))
            }
        }
    }
}
