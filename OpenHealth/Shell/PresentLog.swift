import SwiftUI

extension EnvironmentValues {
    /// Opens the log sheet at a destination. Any screen can offer a Log button without owning the sheet.
    @Entry var presentLog: (LogDestination) -> Void = { _ in }
}
