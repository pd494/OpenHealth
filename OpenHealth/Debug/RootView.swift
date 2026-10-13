import Inject
import SwiftUI

struct RootView: View {
    @ObserveInjection private var inject

    var body: some View {
        NavigationStack {
            TodayView()
                .reloadsOnInjection()
                .toolbar(.hidden, for: .navigationBar)
        }
        .tint(.blue)
        .enableInjection()
    }
}
