import Charts
import SwiftUI

struct MetricTile: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    let value: MetricValue
    let layout: TileLayout
    var showsHandle = true
    var history: [DayValue] = []
    @ScaledMetric(relativeTo: .title) private var figureSize = 26.0

    private var descriptor: MetricDescriptor { value.id.descriptor }
    private var caption: String { value.goalText ?? value.subtitle ?? (value.value == nil ? "No data" : "") }

    var body: some View {
        Group {
            switch layout {
            case .grid: gridContent
            case .list, .pills: listContent
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
        HStack(alignment: .firstTextBaseline, spacing: value.unit == "%" ? 0 : 3) {
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
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(.secondary)
                    .labelStyle(TintedIconLabelStyle(tint: descriptor.tint))
                    .lineLimit(2)
                Spacer(minLength: 0)
                if showsHandle { ReorderHandle(id: value.id) }
            }
            figure
            if history.count > 1 {
                Chart(history) { day in
                    LineMark(x: .value("Date", day.date), y: .value("Value", day.value))
                        .foregroundStyle(descriptor.tint)
                        .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round))
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .chartYScale(domain: .automatic(includesZero: false))
                .frame(height: 20)
                .accessibilityHidden(true)
            } else if let progress = value.progress {
                ProgressBar(ratio: progress, tint: descriptor.tint)
            }
            Text(caption).font(.caption).foregroundStyle(captionTint).lineLimit(1)
                .frame(minHeight: 14, alignment: .leading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private var listContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: descriptor.symbol)
                    .foregroundStyle(descriptor.tint)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 4) {
                    Text(descriptor.title).font(.subheadline.weight(.medium))
                    Text(caption).font(.caption).foregroundStyle(.secondary)
                }
                Spacer(minLength: 8)
                if !typeSize.isAccessibilitySize { figure }
                if showsHandle { ReorderHandle(id: value.id) }
            }
            if typeSize.isAccessibilitySize { figure }
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
