import SwiftUI

struct MacroProgress: View {
    @Environment(\.dynamicTypeSize) private var typeSize

    let macro: Macro

    private var metric: MetricDescriptor { macro.metric }
    private var valueText: String { "\(metric.number) / \(metric.goalText)" }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(metric.title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(valueText)
                .font(.footnote.bold())
                .monospacedDigit()
                .lineLimit(typeSize.isAccessibilitySize ? nil : 1)
                .minimumScaleFactor(0.8)
            ProgressBar(ratio: metric.progress, tint: macro.tint)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(metric.title)
        .accessibilityValue("\(valueText), \(Int((metric.progress * 100).rounded())) percent")
    }
}

#Preview {
    HStack {
        ForEach(Macro.allCases, id: \.self) { MacroProgress(macro: $0) }
    }
    .padding()
}
