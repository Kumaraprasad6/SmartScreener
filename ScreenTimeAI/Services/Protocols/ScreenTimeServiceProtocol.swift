import Foundation

protocol ScreenTimeServiceProtocol {
    var isAuthorized: Bool { get }
    func requestAuthorization() async throws
    func fetchDailyUsage(for date: Date) async throws -> [DailyAppUsage]
    func fetchUsage(for interval: DateInterval) async throws -> [DailyAppUsage]
}
