import SwiftUI

struct MealPhotoPlaceholder: View {
    var body: some View {
        LinearGradient(colors: [.orange.opacity(0.4), .orange.opacity(0.7), MetricDomain.vitals.ringStart], startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(height: 150)
            .overlay {
                HStack(alignment: .top, spacing: 12) {
                    box("Chicken").padding(.top, 20)
                    box("Rice").padding(.top, 32)
                    box("Broccoli")
                }
                .padding(16)
            }
            .clipShape(.rect(cornerRadius: Layout.cardRadius))
            .accessibilityHidden(true)
    }
    private func box(_ title: String) -> some View {
        RoundedRectangle(cornerRadius: 8).stroke(.white, lineWidth: 2)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .topLeading) {
                Text(title).font(.caption).foregroundStyle(.black)
                    .padding(4).background(.white, in: .rect(cornerRadius: 4)).padding(4)
            }
    }
}
#Preview { MealPhotoPlaceholder().padding() }
