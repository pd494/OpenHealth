import SwiftUI

struct EditTray: View {
    @Environment(DashboardLayoutStore.self) private var store
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var hidden: [DashboardItem] { store.layout.hidden.filter { $0.metric.descriptor.hasGoal } }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Available metrics").font(.subheadline.weight(.medium))
                Spacer()
                if !hidden.isEmpty {
                    Button("Add all") {
                        withMotion(reduceMotion: reduceMotion) {
                            for item in hidden { store.layout.setVisible(item.metric, true) }
                        }
                    }
                }
            }
            if hidden.isEmpty {
                Text("Everything is on your dashboard.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 130), spacing: 8)], alignment: .leading, spacing: 8) {
                    ForEach(hidden) { item in
                        Button { withMotion(reduceMotion: reduceMotion) { store.layout.setVisible(item.metric, true) } } label: {
                            Label(item.metric.descriptor.title, systemImage: "plus")
                                .font(.subheadline.weight(.medium))
                                .frame(maxWidth: .infinity, minHeight: Layout.minTapTarget)
                                .background(Palette.card, in: .capsule)
                                .overlay { Capsule().strokeBorder(Palette.separator) }
                        }
                        .buttonStyle(.pressable)
                    }
                }
            }
        }
        .padding(Layout.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .dashedSurface()
    }
}

#Preview {
    EditTray()
        .padding()
        .background(Palette.background)
        .environment(DashboardLayoutStore(layout: .default))
}
