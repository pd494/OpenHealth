import SwiftUI
import WidgetKit

@main
struct OpenHealthWidgets: WidgetBundle {
    var body: some Widget {
        OpenHealthStepsWidget()
        OpenHealthHydrationWidget()
    }
}
