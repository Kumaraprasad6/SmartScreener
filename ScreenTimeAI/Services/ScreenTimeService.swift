import FamilyControls
import Foundation

class ScreenTimeService: ScreenTimeServiceProtocol {

    var isAuthorized: Bool {
        AuthorizationCenter.shared.authorizationStatus == .approved
    }

    func requestAuthorization() async throws {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
    }

    func fetchDailyUsage(for date: Date) async throws -> [DailyAppUsage] {
        let dateString = DateFormatter.isoDate.string(from: date)
        guard let payload = try readPayload(for: dateString) else { return [] }
        return payload.apps.map { entry in
            DailyAppUsage(
                bundleIdentifier: entry.bundleIdentifier,
                displayName: entry.displayName,
                duration: entry.duration,
                date: date,
                categoryIdentifier: entry.categoryIdentifier
            )
        }
    }

    func fetchUsage(for interval: DateInterval) async throws -> [DailyAppUsage] {
        var results: [DailyAppUsage] = []
        var current = interval.start
        let calendar = Calendar.current
        while current < interval.end {
            let daily = try await fetchDailyUsage(for: current)
            results.append(contentsOf: daily)
            guard let next = calendar.date(byAdding: .day, value: 1, to: current) else { break }
            current = next
        }
        return results
    }

    // Overridable in tests
    func readPayload(for dateString: String) throws -> DailyUsagePayload? {
        try AppGroupStore.read(for: dateString)
    }
}
