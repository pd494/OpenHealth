import SwiftUI

struct EditTray: View {
    @Environment(DashboardLayoutStore.self) private var store

    private var hidden: [DashboardItem] { store.layout.hidden }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hidden").eyebrow()
            if hidden.isEmpty {
                Text("Everything is on your dashboard.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 130), spacing: 8)], alignment: .leading, spacing: 8) {
                    ForEach(hidden) { item in
                        Button { withAnimation(.snappy) { store.setVisible(item.metric, true) } } label: {
                            Label(item.metric.descriptor.title, systemImage: "plus")
                                .font(.subheadline.weight(.medium))
                                .frame(maxWidth: .infinity, minHeight: Layout.minTapTarget)
                                .background(Palette.card, in: .capsule)
                                .overlay { Capsule().strokeBorder(Palette.hairline) }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(Layout.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay {
            RoundedRectangle(cornerRadius: Layout.cardRadius)
                .strokeBorder(Palette.stitch, style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

#Preview {
    EditTray()
        .padding()
        .background(Palette.background)
        .environment(DashboardLayoutStore(layout: .default))
}
