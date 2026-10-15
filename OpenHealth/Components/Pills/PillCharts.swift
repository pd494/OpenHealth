import SwiftUI

/// The top half of a ring: a tinted track and a gradient that ends darkest, like the full rings.
struct HalfDial: View {
    private static let lineWidth = 5.0

    let progress: Double
    let tint: Color
    let softTint: Color
    let deepTint: Color

    var body: some View {
        AnimatedProgress(ratio: min(max(progress, 0), 1)) { ratio in
            ZStack {
                Circle()
                    .trim(from: 0.5, to: 1)
                    .stroke(tint.opacity(0.18), style: StrokeStyle(lineWidth: Self.lineWidth, lineCap: .round))
                Circle()
                    .trim(from: 0.5, to: 0.5 + 0.5 * max(ratio, 0.01))
                    .stroke(
                        AngularGradient(
                            colors: [softTint, tint, deepTint],
                            center: .center,
                            startAngle: .degrees(180),
                            endAngle: .degrees(180 + 180 * max(ratio, 0.01))
                        ),
                        style: StrokeStyle(lineWidth: Self.lineWidth, lineCap: .round)
                    )
            }
            .padding(Self.lineWidth / 2)
            .frame(width: 48, height: 48)
            .frame(height: 26, alignment: .top)
        }
        .accessibilityHidden(true)
    }
}

/// A week of bars from a shared baseline; today's is darkest so it reads as "now".
struct MiniBars: View {
    private static let height = 26.0

    let values: [Double]
    let tint: Color
    let softTint: Color
    let deepTint: Color

    var body: some View {
        let peak = max(values.max() ?? 1, 1)
        HStack(alignment: .bottom, spacing: 3) {
            ForEach(values.indices, id: \.self) { index in
                Capsule()
                    .fill(fill(at: index))
                    .frame(width: 4, height: max(Self.height * values[index] / peak, 4))
            }
        }
        .frame(width: 48, height: Self.height, alignment: .bottom)
        .accessibilityHidden(true)
    }

    private func fill(at index: Int) -> LinearGradient {
        let flat = softTint.opacity(0.55)
        let colors = index == values.count - 1 ? [tint, deepTint] : [flat, flat]
        return LinearGradient(colors: colors, startPoint: .bottom, endPoint: .top)
    }
}

/// A smoothed line through the week's readings with a soft fill beneath, ending on a dot for today.
struct MiniWave: View {
    let values: [Double]
    let tint: Color
    let softTint: Color
    let deepTint: Color

    var body: some View {
        GeometryReader { proxy in
            let points = points(in: proxy.size)
            ZStack {
                curve(through: points, closedTo: proxy.size.height)
                    .fill(LinearGradient(colors: [softTint.opacity(0.35), softTint.opacity(0)], startPoint: .top, endPoint: .bottom))
                curve(through: points, closedTo: nil)
                    .stroke(
                        LinearGradient(colors: [softTint, tint, deepTint], startPoint: .leading, endPoint: .trailing),
                        style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round)
                    )
                if let last = points.last {
                    Circle()
                        .fill(deepTint)
                        .frame(width: 6, height: 6)
                        .position(last)
                }
            }
        }
        .frame(width: 48, height: 26)
        .accessibilityHidden(true)
    }

    private func points(in size: CGSize) -> [CGPoint] {
        let low = values.min() ?? 0, high = values.max() ?? 1
        let span = max(high - low, .ulpOfOne)
        let inset = 3.0
        return values.indices.map { index in
            let x = inset + (size.width - inset * 2) * Double(index) / Double(max(values.count - 1, 1))
            let y = inset + (size.height - inset * 2) * (1 - (values[index] - low) / span)
            return CGPoint(x: x, y: y)
        }
    }

    /// Curves through each point via midpoints, so the line stays smooth without overshooting the data.
    private func curve(through points: [CGPoint], closedTo bottom: Double?) -> Path {
        Path { path in
            guard let first = points.first else { return }
            path.move(to: first)
            for (previous, point) in zip(points, points.dropFirst()) {
                let mid = CGPoint(x: (previous.x + point.x) / 2, y: (previous.y + point.y) / 2)
                path.addQuadCurve(to: mid, control: previous)
            }
            if let last = points.last { path.addLine(to: last) }
            if let bottom, let last = points.last {
                path.addLine(to: CGPoint(x: last.x, y: bottom))
                path.addLine(to: CGPoint(x: first.x, y: bottom))
                path.closeSubpath()
            }
        }
    }
}
