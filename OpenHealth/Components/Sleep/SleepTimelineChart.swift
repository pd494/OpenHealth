import SwiftUI

/// The night as four lanes, one block per stretch of a stage. Drag across it to read any moment.
struct SleepTimelineChart: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @ScaledMetric(relativeTo: .caption2) private var laneLabelSize = 9.0
    @GestureState private var scrubX: Double?

    let night: SleepNight
    /// The segment under the finger, for the readout beneath the chart.
    @Binding var scrubbed: SleepSegment?

    private static let blockHeight = 21.0
    private static let laneStep = 29.0
    private static let blockRadius = 6.0
    private static let height = blockHeight + laneStep * 3

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let scale = width / Double(night.inBedMinutes)
            ZStack(alignment: .topLeading) {
                ForEach(SleepStage.allCases, id: \.self) { stage in
                    Rectangle()
                        .fill(Palette.sleepGuide)
                        .frame(height: 1)
                        .offset(y: laneY(stage) - 0.5)
                }
                ForEach(Array(zip(night.segments, night.segments.dropFirst())), id: \.0.id) { segment, next in
                    connector(from: segment, to: next, scale: scale)
                }
                ForEach(night.segments) { segment in
                    block(segment, scale: scale)
                }
                ForEach(SleepStage.allCases, id: \.self) { stage in
                    Text(stage.title)
                        .font(.system(size: laneLabelSize, weight: .bold))
                        .foregroundStyle(Palette.sleepGuideLabel)
                        .offset(x: 2, y: laneY(stage) - 15)
                }
                if let scrubX {
                    Capsule()
                        .fill(Color.primary.opacity(0.3))
                        .frame(width: 1.5, height: Self.height)
                        .offset(x: min(max(scrubX, 0), width) - 0.75)
                }
            }
            .frame(width: width, height: Self.height, alignment: .topLeading)
            .contentShape(.rect)
            // Simultaneous so a drag that turns vertical still scrolls the page, and `@GestureState` resets itself if the touch is cancelled.
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .updating($scrubX) { value, state, _ in state = value.location.x }
            )
            .onChange(of: scrubX) { _, x in
                scrubbed = x.flatMap { night.segment(atMinute: min(max($0, 0), width) / scale) }
            }
        }
        .frame(height: Self.height)
        .animation(Motion.resolve(Motion.press, reduceMotion: reduceMotion), value: scrubbed?.id)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Sleep stages")
        .accessibilityValue(summary)
    }

    private func laneY(_ stage: SleepStage) -> Double {
        Self.blockHeight / 2 + Self.laneStep * Double(SleepStage.allCases.firstIndex(of: stage)!)
    }

    private func block(_ segment: SleepSegment, scale: Double) -> some View {
        let isAwake = segment.stage == .awake
        let width = max(Double(segment.minutes) * scale - 1.2, isAwake ? 2.2 : 4)
        return RoundedRectangle(cornerRadius: isAwake ? width / 2 : Self.blockRadius, style: .continuous)
            .fill(segment.stage.fill)
            .frame(width: width, height: Self.blockHeight)
            .offset(x: Double(segment.start) * scale + 0.6, y: laneY(segment.stage) - Self.blockHeight / 2)
            .opacity(scrubbed == nil || scrubbed?.id == segment.id ? 1 : 0.3)
    }

    /// The faint step between one block and the next, drawn behind both.
    private func connector(from segment: SleepSegment, to next: SleepSegment, scale: Double) -> some View {
        let top = min(laneY(segment.stage), laneY(next.stage))
        let bottom = max(laneY(segment.stage), laneY(next.stage))
        return Capsule()
            .fill(Palette.sleepConnector)
            .frame(width: 2.4, height: bottom - top + 2)
            .offset(x: Double(segment.end) * scale - 1.2, y: top - 1)
    }

    private var summary: String {
        SleepStage.allCases
            .map { "\($0.title) \(SleepNight.duration(night.minutes(in: $0)))" }
            .joined(separator: ", ")
    }
}
