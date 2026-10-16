import SwiftUI

struct SleepStatPair: View {
    @Environment(\.dynamicTypeSize) private var typeSize

    private static let stats = [
        (title: "Sleep debt", value: "1h 24m", caption: "this week", isTinted: false),
        (title: "Avg score", value: "81", caption: "last 30 days", isTinted: true),
    ]

    private var layout: AnyLayout {
        typeSize.isAccessibilitySize ? AnyLayout(VStackLayout(spacing: 12)) : AnyLayout(HStackLayout(spacing: 12))
    }

    var body: some View {
        layout {
            ForEach(Self.stats, id: \.title) { stat in
                VStack(alignment: .leading, spacing: 4) {
                    Text(stat.title)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Text(stat.value)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(stat.isTinted ? MetricDomain.sleep.adaptiveLabel : .primary)
                    Text(stat.caption)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(Layout.cardPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
                .surface()
                .accessibilityElement(children: .combine)
            }
        }
    }
}

#Preview {
    SleepStatPair()
        .padding()
        .background(Palette.background)
}
