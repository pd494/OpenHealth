import Foundation

struct GoogleHealthAPI {
    private static let base = "https://health.googleapis.com/v4/users/me"
    private static let sources = "users/me/dataSourceFamilies/google-sources"
    private static let wearables = "users/me/dataSourceFamilies/google-wearables"

    func dailySteps(daysBack: Int = 7) async throws -> [DailyStepCount] {
        let today = Calendar.current.startOfDay(for: .now)
        let body = DailyRollUpRequest(from: today.adding(-daysBack, .day), to: today.adding(1, .day), dataSourceFamily: Self.sources)
        let response: DailyStepsResponse = try await post("/dataTypes/steps/dataPoints:dailyRollUp", body: body)
        return response.days
    }

    func dailyDashboard(_ dataType: String) async throws -> DailyDashboardResponse {
        let today = Calendar.current.startOfDay(for: .now)
        let body = DailyRollUpRequest(from: today.adding(-7, .day), to: today.adding(1, .day), dataSourceFamily: Self.sources)
        return try await post("/dataTypes/\(dataType)/dataPoints:dailyRollUp", body: body)
    }

    func pairedAir() async throws -> PairedAir? {
        let response: PairedDevicesResponse = try await get("/pairedDevices")
        return response.air
    }

    func lastSleepHours() async throws -> Double? {
        let response: SleepResponse = try await reconcile("sleep", filter: "sleep.interval.civil_end_time >= \"\(dateString(daysAgo: 2))\"")
        return response.lastNightHours
    }

    func dailyMetric(_ kind: DailyMetricKind) async throws -> [DailyMetric] {
        let response: DailyMetricResponse = try await reconcile(kind.dataType, filter: "\(kind.filterKey).date >= \"\(dateString(daysAgo: 8))\"")
        return response.metrics(for: kind)
    }

    private func reconcile<Response: Decodable>(_ dataType: String, filter: String) async throws -> Response {
        try await get("/dataTypes/\(dataType)/dataPoints:reconcile", query: [
            URLQueryItem(name: "dataSourceFamily", value: Self.wearables),
            URLQueryItem(name: "filter", value: filter)
        ])
    }

    private func get<Response: Decodable>(_ path: String, query: [URLQueryItem] = []) async throws -> Response {
        try await send(makeRequest(path, query: query))
    }

    private func post<Response: Decodable>(_ path: String, body: some Encodable) async throws -> Response {
        var request = try await makeRequest(path)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        return try await send(request)
    }

    private func makeRequest(_ path: String, query: [URLQueryItem] = []) async throws -> URLRequest {
        var components = URLComponents(string: Self.base + path)!
        components.queryItems = query.isEmpty ? nil : query
        var request = URLRequest(url: components.url!)
        request.timeoutInterval = 15
        request.setValue("Bearer \(try await GoogleSession.accessToken())", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

    private func send<Response: Decodable>(_ request: URLRequest) async throws -> Response {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw GoogleHealthError("No response from Google Health.") }
        guard (200..<300).contains(http.statusCode) else {
            let detail = try? JSONDecoder().decode(ErrorEnvelope.self, from: data).error.message
            throw GoogleHealthError(detail ?? "Google Health returned \(http.statusCode).")
        }
        return try JSONDecoder.googleHealth.decode(Response.self, from: data)
    }

    private func dateString(daysAgo days: Int) -> String {
        Date.now.adding(-days, .day).formatted(.iso8601.year().month().day().dateSeparator(.dash))
    }

    private struct ErrorEnvelope: Decodable {
        struct Body: Decodable {
            let message: String
        }

        let error: Body
    }
}
