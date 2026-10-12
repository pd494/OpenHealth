import SwiftUI

enum SleepStage: Int, CaseIterable, Identifiable {
    case awake
    case rem
    case core
    case deep

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .awake: "Awake"
        case .rem: "REM"
        case .core: "Light"
        case .deep: "Deep"
        }
    }

    var color: Color {
        switch self {
        case .awake: Palette.sleepAwake
        case .rem: Palette.sleepREM
        case .core: Palette.sleep
        case .deep: Palette.sleepDeep
        }
    }
}
