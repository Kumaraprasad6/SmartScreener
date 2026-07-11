import XCTest
import SwiftData
@testable import ScreenTimeAI

@MainActor
final class PersistenceServiceTests: XCTestCase {
    var container: ModelContainer!
    var service: PersistenceService!

    override func setUp() async throws {
        container = try ModelContainer(
            for: DailyAppUsage.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        service = PersistenceService(modelContext: container.mainContext)
    }

    func testSaveAndFetchByDate() async throws {
        let date = Calendar.current.startOfDay(for: Date())
        let usage = DailyAppUsage(
            bundleIdentifier: "com.instagram.Instagram",
            displayName: "Instagram",
            duration: 3600,
            date: date
        )

        try await service.save([usage])
        let fetched = try await service.fetchUsage(for: date)

        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched[0].bundleIdentifier, "com.instagram.Instagram")
        XCTAssertEqual(fetched[0].duration, 3600)
    }

    func testFetchByDateReturnsOnlyMatchingDate() async throws {
        let today = Calendar.current.startOfDay(for: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!

        try await service.save([
            DailyAppUsage(bundleIdentifier: "com.a", displayName: "A", duration: 100, date: today),
            DailyAppUsage(bundleIdentifier: "com.b", displayName: "B", duration: 200, date: yesterday)
        ])

        let fetched = try await service.fetchUsage(for: today)
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched[0].bundleIdentifier, "com.a")
    }

    func testFetchByInterval() async throws {
        let today = Calendar.current.startOfDay(for: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!

        try await service.save([
            DailyAppUsage(bundleIdentifier: "com.a", displayName: "A", duration: 100, date: today),
            DailyAppUsage(bundleIdentifier: "com.b", displayName: "B", duration: 200, date: yesterday)
        ])

        let interval = DateInterval(start: yesterday, end: tomorrow)
        let fetched = try await service.fetchUsage(for: interval)
        XCTAssertEqual(fetched.count, 2)
    }

    func testFetchAllDatesDeduplicates() async throws {
        let today = Calendar.current.startOfDay(for: Date())

        try await service.save([
            DailyAppUsage(bundleIdentifier: "com.a", displayName: "A", duration: 100, date: today),
            DailyAppUsage(bundleIdentifier: "com.b", displayName: "B", duration: 200, date: today)
        ])

        let dates = try await service.fetchAllDates()
        XCTAssertEqual(dates.count, 1)
        XCTAssertEqual(Calendar.current.startOfDay(for: dates[0]), today)
    }
}
