import FoundationModels
import SwiftUI

@MainActor
struct HealthInsights {
    let health: HealthManager
    let google: GoogleHealthManager

    static let suggestedQuestions = ["How many steps?", "Why is recovery low?"]

    private static let instructions = """
        Explain the supplied health statistics in plain language. Use only the supplied facts.
        Never invent a measurement, cause, diagnosis, or treatment. Do not perform new arithmetic.
        If data is missing, say what is missing. Distinguish a possible contributor from a proven cause.
        Keep the response under 130 words.
        """

    func answer(to question: String) async -> String {
        if #available(iOS 26.0, *), SystemLanguageModel.default.isAvailable,
           let generated = await generatedAnswer(to: question) {
            return generated
        }
        return fallbackAnswer(for: question)
    }

    @available(iOS 26.0, *)
    private func generatedAnswer(to question: String) async -> String? {
        let session = LanguageModelSession(instructions: Self.instructions)
        // A model that isn't ready yet is not an error worth surfacing; the fallback still answers.
        return try? await session.respond(to: "Facts:\n\(factSummary)\n\nQuestion: \(question)").content
    }

    var factSummary: String {
        let stepHistory = google.dailySteps.prefix(7)
            .map { "\($0.date.formatted(.dateTime.weekday(.abbreviated))): \($0.count) steps" }
            .joined(separator: ", ")
        let sleepGap = max(0, health.sleepGoal - health.sleepHours)
        return """
            Source: \(sourceName). Steps today: \(health.steps) of \(health.stepGoal) goal.
            Recent step days: \(stepHistory.isEmpty ? "not available" : stepHistory).
            Sleep: \(oneDecimal(health.sleepHours)) hours; goal \(oneDecimal(health.sleepGoal)) hours; shortfall \(oneDecimal(sleepGap)) hours.
            Recovery estimate: \(health.recoveryScore.map(String.init) ?? "unavailable") percent.
            Latest HRV: \(oneDecimal(health.hrv.today)) ms; prior baseline: \(oneDecimal(health.hrv.baseline)) ms.
            Latest resting heart rate: \(oneDecimal(health.rhr.today)) bpm; prior baseline: \(oneDecimal(health.rhr.baseline)) bpm.
            Hydration logged: \(Int(health.waterOunces.rounded())) of \(Int(health.waterGoal)) oz.
            Fitbit Air last device sync: \(airSyncText ?? "unknown").
            """
    }

    func fallbackAnswer(for question: String) -> String {
        let text = question.lowercased()
        func mentions(_ words: String...) -> Bool { words.contains { text.contains($0) } }

        if mentions("step", "walk") { return stepsAnswer }
        if mentions("recover", "tired", "sleep", "energy") { return recoveryAnswer }
        if mentions("water", "hydrat") {
            return "You have logged \(Int(health.waterOunces.rounded())) oz of your \(Int(health.waterGoal)) oz goal today."
        }
        if mentions("sync", "fitbit") { return syncAnswer }
        return "I can answer questions about today's steps, sleep, hydration, recovery estimate, and Fitbit sync time."
    }

    private var stepsAnswer: String {
        var answer = "You have \(health.steps.formatted()) steps toward a \(health.stepGoal.formatted()) step goal from \(sourceName)."
        if google.isConnected {
            answer += " The Fitbit Air last synced \(airSyncText.map { "at \($0)" } ?? "at an unknown time")."
        }
        return answer
    }

    private var recoveryAnswer: String {
        guard let score = health.recoveryScore else {
            return "I don't have enough sleep, HRV, and resting heart rate history to explain a recovery estimate yet. Your recorded sleep is \(oneDecimal(health.sleepHours)) hours."
        }
        var contributors: [String] = []
        if health.sleepHours < health.sleepGoal {
            contributors.append("sleep was below your \(oneDecimal(health.sleepGoal))-hour goal")
        }
        if health.hrv.isBelowBaseline {
            contributors.append("HRV was below your recent baseline")
        }
        if health.rhr.isAboveBaseline {
            contributors.append("resting heart rate was above your recent baseline")
        }
        let detail = contributors.isEmpty
            ? "No single low input stands out in the available measurements."
            : "Possible contributors: \(contributors.joined(separator: ", "))."
        return "Your recovery estimate is \(score)%. \(detail) These numbers cannot determine why you feel tired."
    }

    private var syncAnswer: String {
        guard let airSyncText else {
            return "The Fitbit Air's last sync time is unavailable. Connect Google Health and check that the Air is paired to that account."
        }
        let checked = google.lastChecked?.formatted(date: .omitted, time: .shortened) ?? "an unknown time"
        return "Fitbit Air last synced at \(airSyncText). The app checked Google Health at \(checked)."
    }

    private var sourceName: String {
        if google.isConnected { return google.airName ?? "Google Health wearables" }
        return health.isDemo ? "preview data" : "Apple Health"
    }

    private var airSyncText: String? {
        google.lastAirSync?.formatted(date: .abbreviated, time: .shortened)
    }

    private func oneDecimal(_ value: Double?) -> String {
        value?.formatted(.number.precision(.fractionLength(1))) ?? "unavailable"
    }
}
