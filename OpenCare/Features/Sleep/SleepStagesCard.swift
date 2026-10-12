import SwiftUI

struct SleepStagesCard: View {
    let night: SleepNight

    private var timeInBed: TimeInterval { night.segments.reduce(0) { $0 + $1.duration } }

    var body: some View {
        VStack(spacing: 14) {
            ForEach(SleepStage.allCases) { stage in
                let duration = night.duration(of: stage)
                let share = timeInBed > 0 ? duration / timeInBed : 0
                VStack(spacing: 8) {
                    HStack {
                        Circle().fill(stage.color).frame(width: 8, height: 8).accessibilityHidden(true)
                        Text(stage.title).font(.subheadline.weight(.medium))
                        Spacer()
                        Text(share, format: .percent.precision(.fractionLength(0)))
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        Text(Duration.seconds(duration).formatted(.units(allowed: [.hours, .minutes], width: .narrow)))
                            .metricNumber(.subheadline)
                            .frame(minWidth: 72, alignment: .trailing)
                    }
                    ProgressBar(ratio: share, tint: stage.color)
                }
                .accessibilityElement(children: .combine)
            }
        }
        .card()
    }
}
