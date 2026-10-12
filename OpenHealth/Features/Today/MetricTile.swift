import SwiftUI

struct MetricTile: View {
    let value: MetricValue
    let layout: TileLayout
    var showsHandle = true
    @ScaledMetric(relativeTo: .title) private var figureSize = 28.0

    private var descriptor: MetricDescriptor { value.id.descriptor }
    private var caption: String { value.goalText ?? value.subtitle ?? (value.value == nil ? "No data" : "") }

    var body: some View {
        Group {
            switch layout {
            case .grid: gridContent
            case .list: listContent
            }
        }
        .padding(Layout.tilePadding)
        .surface()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(descriptor.title)
        .accessibilityValue("\(value.number) \(value.unit) \(caption)")
    }

    private var captionTint: Color {
        guard value.id == .stress, let score = value.value else { return .secondary }
        return StressScore.band(score).color
    }

    private var figure: some View {
        HStack(alignment: .firstTextBaseline, spacing: 3) {
            Text(value.number)
                .metricFigure(layout == .grid ? figureSize : figureSize * 0.82)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
            if !value.unit.isEmpty {
                Text(value.unit).font(.caption.weight(.medium)).foregroundStyle(.secondary)
            }
        }
    }

    private var gridContent: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Label(descriptor.title, systemImage: descriptor.symbol)
                    .cardTitle()
                    .labelStyle(TintedIconLabelStyle(tint: descriptor.tint))
                    .lineLimit(1)
                Spacer(minLength: 0)
                if showsHandle { ReorderHandle(id: value.id) }
            }
            Spacer(minLength: 0)
            figure
            if let progress = value.progress {
                ProgressBar(ratio: progress, tint: descriptor.tint)
            } else {
                Color.clear.frame(height: ProgressBar.defaultHeight)
            }
            Text(caption).font(.caption2).foregroundStyle(captionTint).lineLimit(1)
                .frame(minHeight: 14, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var listContent: some View {
        HStack(spacing: 12) {
            Image(systemName: descriptor.symbol)
                .foregroundStyle(descriptor.tint)
                .frame(width: 34, height: 34)
                .background(descriptor.tint.opacity(0.14), in: .circle)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(descriptor.title).font(.subheadline.weight(.medium))
                Text(caption).font(.caption).foregroundStyle(.secondary).lineLimit(1)
            }
            Spacer(minLength: 8)
            figure
            if showsHandle { ReorderHandle(id: value.id) }
        }
    }
}

private struct TintedIconLabelStyle: LabelStyle {
    let tint: Color

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 6) {
            configuration.icon.foregroundStyle(tint)
            configuration.title
        }
    }
}

#Preview {
    VStack {
        MetricTile(value: MetricValue(id: .steps, value: 6_428, goal: 10_000, subtitle: nil), layout: .grid)
            .frame(height: Layout.gridTileHeight)
        MetricTile(value: MetricValue(id: .weight, value: nil, goal: nil, subtitle: nil), layout: .list)
            .frame(height: Layout.listTileHeight)
    }
    .padding()
    .background(Palette.background)
}
