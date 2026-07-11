import Foundation

// Shared App Group container used to pass aggregated usage data
// from the DeviceActivityReportExtension to the main app.
enum AppGroup {
    static let identifier = "group.com.stella.ScreenTimeAI"

    static var containerURL: URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: identifier)
    }
}
