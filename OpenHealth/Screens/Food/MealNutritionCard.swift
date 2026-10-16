import SwiftUI

struct MealNutritionCard: View {
    @Environment(\.dynamicTypeSize) private var typeSize
    private static let macros: [(name: String, grams: Double, color: Color)] = [
        ("Protein", 48, .pink), ("Carbs", 62, MetricDomain.nutrition.ringStart), ("Fat", 18, .orange)
    ]
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            let layout = typeSize.isAccessibilitySize ? AnyLayout(VStackLayout(alignment: .leading, spacing: 8)) : AnyLayout(HStackLayout(spacing: 12))
            layout {
                VStack(alignment: .leading, spacing: 4) {
                    Text("640 \(Text("kcal").font(.subheadline).foregroundStyle(.secondary))").font(.largeTitle).bold()
                    Text("32% of today's goal").font(.footnote).foregroundStyle(.secondary)
                }
                .accessibilityElement(children: .combine)
                layout {
                    ForEach(Self.macros, id: \.name) { macro in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(macro.name).font(.caption).foregroundStyle(.secondary)
                            Text("\(macro.grams, format: .number) g").font(.subheadline).bold()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityElement(children: .combine)
                    }
                }
            }
            Canvas { context, size in
                let total = Self.macros.reduce(0) { $0 + $1.grams }
                var x = 0.0
                for macro in Self.macros {
                    let width = size.width * macro.grams / total
                    context.fill(Path(CGRect(x: x, y: 0, width: width, height: size.height)), with: .color(macro.color))
                    x += width
                }
            }
            .frame(height: 8).clipShape(.capsule).accessibilityHidden(true)
        }
        .padding(16).surface()
    }
}
#Preview { MealNutritionCard().padding().pageBackground() }
