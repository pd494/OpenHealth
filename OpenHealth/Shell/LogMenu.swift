import SwiftUI

/// What to log, one row each. Food comes first because it's the thing logged most often.
struct LogMenu: View {
    private static let rows: [(destination: LogDestination, subtitle: String)] = [
        (.food, "Search, scan a barcode or describe a meal"),
        (.activity, "Walk, run, lift and more"),
        (.water, "Add a glass or a bottle"),
        (.weight, "Record today's weigh-in"),
    ]

    var body: some View {
        List(Self.rows, id: \.destination) { row in
            NavigationLink(value: row.destination) {
                Label {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(row.destination.title).font(.headline)
                        Text(row.subtitle).font(.subheadline).foregroundStyle(.secondary)
                    }
                } icon: {
                    Image(systemName: row.destination.symbol)
                        .foregroundStyle(Color.accentColor)
                }
            }
        }
        .navigationTitle("Log")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { LogMenu() }
}
