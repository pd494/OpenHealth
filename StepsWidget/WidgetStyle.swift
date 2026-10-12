import SwiftUI
import WidgetKit

extension View {
    func widgetStyle(opening link: DeepLink) -> some View {
        foregroundStyle(.white)
            .containerBackground(Palette.widgetBackground, for: .widget)
            .widgetURL(link.url)
    }
}
