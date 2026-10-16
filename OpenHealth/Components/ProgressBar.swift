import SwiftUI

/// A 6pt capsule that eases up to `ratio` over a faint track.
struct ProgressBar: View {
    let ratio: Double
    let tint: Color

    var body: some View {
        AnimatedProgress(ratio: min(max(ratio, 0), 1)) { shown in
            Capsule()
                .fill(tint.opacity(0.2))
                .overlay(alignment: .leading) {
                    Capsule().fill(tint).scaleEffect(x: shown, anchor: .leading)
                }
        }
        .frame(height: 6)
    }
}

#Preview {
    ProgressBar(ratio: 0.6, tint: MetricDomain.nutrition.ringStart)
        .padding()
}
