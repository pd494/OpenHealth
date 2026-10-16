import SwiftUI

struct ActivityKindPicker: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    @Binding var selection: ActivityKind

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: typeSize.isAccessibilitySize ? 140 : 108), spacing: 8)]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Activity type")
                .font(.subheadline.bold())
                .accessibilityAddTraits(.isHeader)
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(ActivityKind.allCases, id: \.self) { kind in
                    Button { selection = kind } label: {
                        Label(kind.title, systemImage: kind.symbol)
                            .font(.subheadline.weight(.semibold))
                            .lineLimit(1)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, minHeight: Layout.minTapTarget)
                            .foregroundStyle(selection == kind ? .white : Color.primary)
                            .background(selection == kind ? Color.black : Palette.card, in: .capsule)
                            .shadow(color: Palette.contactShadow, radius: 1.5, y: 1)
                            .shadow(color: Palette.ambientShadow, radius: 14, y: 8)
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(selection == kind ? .isSelected : [])
                }
            }
        }
        .sensoryFeedback(.selection, trigger: selection)
    }
}

#Preview { ActivityKindPicker(selection: .constant(.walk)).padding() }
