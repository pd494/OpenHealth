import SwiftUI

struct SettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var path = DebugLaunch.string("settings")
        .flatMap(SettingsRoute.init(rawValue:))
        .map { [$0] } ?? []

    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section {
                    NavigationLink(value: SettingsRoute.goals) {
                        Label("Goals", systemImage: "target")
                    }
                    NavigationLink(value: SettingsRoute.sources) {
                        Label("Data sources", systemImage: "arrow.triangle.2.circlepath")
                    }
                }
                Section {
                    Button("Export my data", systemImage: "square.and.arrow.up") {}
                    Button("Delete all data", systemImage: "trash") {}
                        .foregroundStyle(.red)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: SettingsRoute.self) { route in
                switch route {
                case .goals: GoalsView()
                case .sources: ConnectDataView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    SettingsSheet()
}
