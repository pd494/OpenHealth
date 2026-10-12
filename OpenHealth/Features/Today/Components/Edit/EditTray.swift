import SwiftUI

struct EditTray: View {
    @Environment(DashboardLayoutStore.self) private var store
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var hidden: [DashboardItem] { store.layout.hidden }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hidden").cardTitle()
            if hidden.isEmpty {
                Text("Everything is on your dashboard.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 130), spacing: 8)], alignment: .leading, spacing: 8) {
                    ForEach(hidden) { item in
                        Button { withMotion(reduceMotion: reduceMotion) { store.setVisible(item.metric, true) } } label: {
                            Label(item.metric.descriptor.title, systemImage: "plus")
                                .font(.subheadline.weight(.medium))
                                .frame(maxWidth: .infinity, minHeight: Layout.minTapTarget)
                                .background(Palette.card, in: .capsule)
                                .overlay { Capsule().strokeBorder(Palette.hairline) }
                        }
                        .buttonStyle(.pressable)
                    }
                }
            }
        }
        .padding(Layout.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .dashedSurface()
        .softLift()
    }
}

#Preview {
    EditTray()
        .padding()
        .background(Palette.background)
        .environment(DashboardLayoutStore(layout: .default))
}
