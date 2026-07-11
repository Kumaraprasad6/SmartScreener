import XCTest
import SwiftData
@testable import ScreenTimeAI

@MainActor
final class DashboardViewModelTests: XCTestCase {
    var container: ModelContainer!
    var mockScreenTime: MockScreenTimeService!
    var mockInsights: MockInsightsEngine!
    var persistenceService: PersistenceService!

    override func setUp() async throws {
        container = try ModelContainer(
            for: DailyAppUsage.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        persistenceService = PersistenceService(modelContext: container.mainContext)
        mockScreenTime = MockScreenTimeService()
        mockInsights = MockInsightsEngine()
    }

    func testLoadTodayPopulatesTotalDuration() async throws {
        let today = Date()
        mockScreenTime.stubbedUsage = [
            DailyAppUsage(bundleIdentifier: "com.a", displayName: "A", duration: 3600, date: today),
            DailyAppUsage(bundleIdentifier: "com.b", displayName: "B", duration: 1800, date: today)
        ]

        let vm = DashboardViewModel(
            screenTimeService: mockScreenTime,
            persistenceService: persistenceService,
            insightsEngine: mockInsights
        )
        await vm.loadToday()

        XCTAssertEqual(vm.totalDuration, 5400)
        XCTAssertFalse(vm.isLoading)
    }

    func testLoadTodayPopulatesTop3Apps() async throws {
        let today = Date()
        mockScreenTime.stubbedUsage = [
            DailyAppUsage(bundleIdentifier: "com.a", displayName: "A", duration: 100, date: today),
            DailyAppUsage(bundleIdentifier: "com.b", displayName: "B", duration: 400, date: today),
            DailyAppUsage(bundleIdentifier: "com.c", displayName: "C", duration: 200, date: today),
            DailyAppUsage(bundleIdentifier: "com.d", displayName: "D", duration: 300, date: today)
        ]

        let vm = DashboardViewModel(
            screenTimeService: mockScreenTime,
            persistenceService: persistenceService,
            insightsEngine: mockInsights
        )
        await vm.loadToday()

        XCTAssertEqual(vm.topApps.count, 3)
        XCTAssertEqual(vm.topApps[0].bundleIdentifier, "com.b") // highest
        XCTAssertEqual(vm.topApps[1].bundleIdentifier, "com.d")
        XCTAssertEqual(vm.topApps[2].bundleIdentifier, "com.c")
    }

    func testLoadTodayHandlesEmptyUsage() async throws {
        mockScreenTime.stubbedUsage = []
        let vm = DashboardViewModel(
            screenTimeService: mockScreenTime,
            persistenceService: persistenceService,
            insightsEngine: mockInsights
        )
        await vm.loadToday()
        XCTAssertEqual(vm.totalDuration, 0)
        XCTAssertTrue(vm.topApps.isEmpty)
    }
}

// MARK: - Mocks

final class MockScreenTimeService: ScreenTimeServiceProtocol {
    var isAuthorized = true
    var stubbedUsage: [DailyAppUsage] = []

    func requestAuthorization() async throws {}

    func fetchDailyUsage(for date: Date) async throws -> [DailyAppUsage] {
        stubbedUsage
    }

    func fetchUsage(for interval: DateInterval) async throws -> [DailyAppUsage] {
        stubbedUsage
    }
}

final class MockInsightsEngine: InsightsEngineProtocol {
    func generateInsight(from usage: [DailyAppUsage]) async -> String { "" }
    func generateSuggestions(timeSaved: TimeInterval) async -> [String] { [] }
}
