import SwiftUI

struct WidgetFootnote: View {
    let text: Text

    var body: some View {
        text
            .font(.caption2)
            .foregroundStyle(.white.opacity(0.47))
            .lineLimit(1)
            .minimumScaleFactor(0.8)
    }
}
