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
        font(.system(size: size, weight: .semibold, design: .rounded))
            .monospacedDigit()
            .tracking(-0.5)
            .contentTransition(.numericText())
    }

    func eyebrow() -> some View {
        font(.caption2.weight(.semibold))
            .textCase(.uppercase)
            .tracking(1.2)
            .foregroundStyle(.secondary)
    }
}
