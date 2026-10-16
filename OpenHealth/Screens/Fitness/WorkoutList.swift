import SwiftUI

struct WorkoutList: View {
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Workout.recent) { workout in
                WorkoutRow(workout: workout)
                if workout.id != Workout.recent.last!.id {
                    Hairline(axis: .horizontal)
                }
            }
        }
        .padding(.horizontal, Layout.cardPadding)
        .surface()
    }
}

#Preview {
    WorkoutList().padding().pageBackground()
}
