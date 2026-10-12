import SwiftUI

extension View {
    /// Large rounded figure with tabular digits and tight tracking.
    func metricNumber(_ style: Font.TextStyle = .title2, weight: Font.Weight = .semibold) -> some View {
        font(.rounded(style, weight: weight))
            .monospacedDigit()
            .tracking(-0.6)
            .contentTransition(.numericText())
    }

    func metricFigure(_ size: Double) -> some View {
        font(.system(size: size, weight: .medium, design: .default))
            .monospacedDigit()
            .tracking(-0.5)
            .contentTransition(.numericText())
    }

    func cardTitle() -> some View {
        font(.subheadline.weight(.medium)).foregroundStyle(.primary)
    }

}
