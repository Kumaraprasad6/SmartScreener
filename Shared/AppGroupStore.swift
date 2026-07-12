import Foundation

struct DailyUsagePayload: Codable {
    let date: String        // "yyyy-MM-dd"
    let apps: [AppUsageEntry]
}

struct AppUsageEntry: Codable {
    let bundleIdentifier: String
    let displayName: String
    let duration: TimeInterval
    let categoryIdentifier: String?
}

enum AppGroupStore {
    static let groupIdentifier = "group.com.stella.ScreenTimeAI"
    private static let filename = "daily_usage_payload.json"

    private static var containerURL: URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier)
    }

    static func write(_ payload: DailyUsagePayload) throws {
        guard let url = containerURL?.appendingPathComponent(filename) else { return }
        let data = try JSONEncoder().encode(payload)
        try data.write(to: url, options: .atomic)
    }

    static func read(for dateString: String) throws -> DailyUsagePayload? {
        guard let url = containerURL?.appendingPathComponent(filename),
              let data = try? Data(contentsOf: url) else { return nil }
        let payload = try JSONDecoder().decode(DailyUsagePayload.self, from: data)
        return payload.date == dateString ? payload : nil
    }
}

extension DateFormatter {
    static let isoDate: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()
}
