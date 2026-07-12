import Foundation

@MainActor
protocol PersistenceServiceProtocol {
    func save(_ usage: [DailyAppUsage]) async throws
    func fetchUsage(for date: Date) async throws -> [DailyAppUsage]
    func fetchUsage(for interval: DateInterval) async throws -> [DailyAppUsage]
    func fetchAllDates() async throws -> [Date]
}
