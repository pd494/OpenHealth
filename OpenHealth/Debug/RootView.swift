import Inject
import SwiftUI

struct RootView: View {
    @ObserveInjection private var inject

    var body: some View {
        MainTabs()
            .reloadsOnInjection()
            .tint(.blue)
            .enableInjection()
    }
}
