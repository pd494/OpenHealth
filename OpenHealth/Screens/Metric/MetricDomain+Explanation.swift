extension MetricDomain {
    var explanation: String {
        switch self {
        case .activity: "Your activity patterns show how movement adds up over time. Compare days to see your usual rhythm."
        case .nutrition: "Your nutrition patterns reflect what you eat over time. Daily needs and intake can vary."
        case .hydration: "Your fluid intake adds up throughout the day. Your usual pattern can help you keep track."
        case .sleep: "Your sleep patterns reflect the time you spend resting. Consistent sleep and wake times can support recovery."
        case .body: "Body measurements naturally fluctuate. Longer-term trends give more context than a single reading."
        case .cardio: "Your cardiovascular patterns reflect activity and recovery. Compare readings over time to understand your usual range."
        case .vitals: "Your vital signs vary with rest, activity and daily routines. Trends help put a single reading in context."
        }
    }
}
