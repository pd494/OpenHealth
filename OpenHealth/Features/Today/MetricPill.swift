import SwiftUI

/// Compact capsule tile. Goal metrics fill the capsule with their tint as progress is made;
/// everything else sits on the neutral card surface.
struct MetricPill: View {
    let value: MetricValue
    var showsHandle = true

    private var descriptor: MetricDescriptor { value.id.descriptor }
    private var caption: String? { value.goalText ?? value.subtitle ?? (value.value == nil ? "No data" : nil) }
    private var isTinted: Bool { value.progress != nil }

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: descriptor.symbol)
                .font(.body.weight(.semibold))
                .foregroundStyle(isTinted ? .white : descriptor.tint)
                .frame(width: 38, height: 38)
                .background(.black.opacity(isTinted ? 0.22 : 0.3), in: .circle)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 0) {
                Text(descriptor.title)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.white.opacity(0.72))
                    .lineLimit(1)
                figure
                if let caption, value.value == nil || value.progress == nil {
                    Text(caption).font(.caption2).foregroundStyle(.white.opacity(0.6)).lineLimit(1)
                }
            }
            Spacer(minLength: 0)
            if showsHandle { ReorderHandle(id: value.id) }
        }
        .padding(.leading, 8)
        .padding(.trailing, 4)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background { background }
        .overlay { Capsule(style: .continuous).strokeBorder(Palette.rim, lineWidth: 0.75) }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(descriptor.title)
        .accessibilityValue("\(value.number) \(value.unit) \(caption ?? "")")
    }

    private var figure: some View {
        HStack(alignment: .firstTextBaseline, spacing: value.unit == "%" ? 0 : 3) {
            Text(value.number)
                .metricNumber(.title3, weight: .semibold)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            if !value.unit.isEmpty {
                Text(value.unit).font(.caption.weight(.medium)).foregroundStyle(.white.opacity(0.72))
            }
        }
    }

    @ViewBuilder private var background: some View {
        let shape = Capsule(style: .continuous)
        if let progress = value.progress {
            AnimatedProgress(ratio: progress) { ratio in
                shape
                    .fill(descriptor.tint.opacity(0.28))
                    .overlay(alignment: .leading) {
                        GeometryReader { proxy in
                            Rectangle()
                                .fill(descriptor.tint.opacity(0.42))
                                .frame(width: proxy.size.width * min(max(ratio, 0), 1))
                        }
                    }
                    .clipShape(shape)
                    .background(Palette.card, in: shape)
            }
            .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
        } else {
            shape
                .fill(Palette.card)
                .overlay { shape.fill(Palette.sheen) }
                .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
        }
    }
}
