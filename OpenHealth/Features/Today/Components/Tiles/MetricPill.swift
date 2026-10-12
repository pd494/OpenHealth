import SwiftUI

struct MetricPill: View {
    let value: MetricValue
    var showsHandle = true

    private var descriptor: MetricDescriptor { value.id.descriptor }
    private var caption: String { value.goalText ?? value.subtitle ?? (value.value == nil ? "No data" : "") }

    var body: some View {
        HStack(spacing: 10) {
            badge
            VStack(alignment: .leading, spacing: 0) {
                Text(descriptor.title)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.primary.opacity(0.65))
                    .lineLimit(1)
                HStack(alignment: .firstTextBaseline, spacing: 3) {
                    Text(value.number).metricNumber(.headline, weight: .semibold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    if !value.unit.isEmpty {
                        Text(value.unit).font(.caption).foregroundStyle(.primary.opacity(0.65))
                    }
                }
            }
            Spacer(minLength: 0)
            if showsHandle { ReorderHandle(id: value.id) }
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .surface(radius: Layout.chipRadius, tint: descriptor.tint)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(descriptor.title)
        .accessibilityValue("\(value.number) \(value.unit) \(caption)")
    }

    /// Icon inside a mini progress ring: goal metrics show how far along they are, the rest a tinted disc.
    private var badge: some View {
        ZStack {
            Circle().fill(descriptor.tint.opacity(0.22))
            if let progress = value.progress {
                AnimatedProgress(ratio: progress) { DepthRing(ratio: $0, lineWidth: 3, tint: descriptor.tint) }
            }
            Image(systemName: descriptor.symbol)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(descriptor.tint)
        }
        .frame(width: 32, height: 32)
        .accessibilityHidden(true)
    }
}
