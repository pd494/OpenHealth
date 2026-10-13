import SwiftUI

struct VerticalHairline: View {
    var body: some View {
        Rectangle()
            .fill(Palette.hairline)
            .frame(width: 1)
            .accessibilityHidden(true)
    }
}
