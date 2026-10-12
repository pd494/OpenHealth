import SwiftUI

struct MetricRing: View {
    let title: String
    let value: String
    let detail: String
    let ratio: Double
    let systemName: String

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                ProgressRing(ratio: ratio, lineWidth: 10)
                VStack(spacing: 1) {
                    Image(systemName: systemName)
                        .font(.caption)
                        .foregroundStyle(Palette.progress(ratio))
                    Text(value)
                        .font(.rounded(value.count > 5 ? .headline : .title3))
                        .minimumScaleFactor(0.72)
                        .lineLimit(1)
                }
                .padding(.horizontal, 9)
            }
            .frame(width: 92, height: 92)
            Text(title)
                .font(.subheadline.weight(.medium))
            Text(detail)
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title), \(value), \(detail)")
    }
}
