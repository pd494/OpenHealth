import SwiftUI

struct EditTray: View {
    @Environment(DashboardLayoutStore.self) private var store
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var hidden: [DashboardItem] { store.layout.hidden }
    private var isFull: Bool { store.layout.isMetricGridFull }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Available metrics").cardTitle()
                Spacer()
                if !hidden.isEmpty && !isFull {
                    Button("Add all") {
                        withMotion(reduceMotion: reduceMotion) {
                            for item in hidden { store.setVisible(item.metric, true) }
                        }
                    }
                }
            }
            if isFull {
                Text("Your dashboard holds \(DashboardLayout.maxMetrics) metrics. Remove one to add another.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
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
                        .disabled(isFull)
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
