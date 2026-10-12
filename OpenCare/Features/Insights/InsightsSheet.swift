import SwiftUI

struct InsightsSheet: View {
    @Environment(HealthManager.self) private var health
    @Environment(GoogleHealthManager.self) private var google
    @State private var question = ""
    @State private var answer = ""
    @State private var isAnswering = false

    private var canAsk: Bool {
        !question.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isAnswering
    }

    var body: some View {
        SheetContainer(title: "OpenCare insights") {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Ask about your day")
                        .font(.largeTitle.bold())
                    Text("Answers use your OpenCare data. On supported iPhones, Apple’s on-device model explains the numbers; a built-in summary works everywhere else.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    HStack {
                        TextField("Why is my recovery low?", text: $question, axis: .vertical)
                            .lineLimit(1...3)
                            .submitLabel(.send)
                            .onSubmit(submit)
                        Button("Ask question", systemImage: "arrow.up.circle.fill", action: submit)
                            .labelStyle(.iconOnly)
                            .font(.title)
                            .disabled(!canAsk)
                    }
                    .padding(14)
                    .inputSurface(radius: 17)
                    HStack {
                        ForEach(HealthInsights.suggestedQuestions, id: \.self) { prompt in
                            Button(prompt) {
                                question = prompt
                                submit()
                            }
                            .font(.caption)
                            .buttonStyle(.bordered)
                        }
                    }
                    if isAnswering { ProgressView("Checking your stats…") }
                    if !answer.isEmpty {
                        Text(answer)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(Layout.cardPadding)
                            .inputSurface()
                            .accessibilityAddTraits(.updatesFrequently)
                    }
                }
                .padding(Layout.sheetPadding)
            }
        }
    }

    private func submit() {
        Task { await ask() }
    }

    private func ask() async {
        let asked = question.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !asked.isEmpty else { return }
        isAnswering = true
        defer { isAnswering = false }
        answer = await HealthInsights(health: health, google: google).answer(to: asked)
    }
}

#Preview {
    InsightsSheet()
        .environment(HealthManager.preview)
        .environment(GoogleHealthManager.shared)
}
