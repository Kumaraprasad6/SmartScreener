import XCTest
@testable import ScreenTimeAI

final class ScreenTimeServiceTests: XCTestCase {

    // MARK: - fetchDailyUsage mapping

    func testFetchDailyUsageMapsPayloadToDailyAppUsage() async throws {
        // Write mock payload to a temp URL then swap AppGroupStore's URL
        // We test the mapping logic via a subclass seam.
        let service = MockableScreenTimeService()
        service.stubbedPayload = DailyUsagePayload(
            date: "2026-07-11",
            apps: [
                AppUsageEntry(bundleIdentifier: "com.instagram.Instagram",
                              displayName: "Instagram",
                              duration: 3600,
                              categoryIdentifier: "SocialNetworking"),
                AppUsageEntry(bundleIdentifier: "com.apple.mobilesafari",
                              displayName: "Safari",
                              duration: 900,
                              categoryIdentifier: nil)
            ]
        )

        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        var comps = DateComponents()
        comps.year = 2026; comps.month = 7; comps.day = 11
        let july11 = cal.date(from: comps)!

        let result = try await service.fetchDailyUsage(for: july11)

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].bundleIdentifier, "com.instagram.Instagram")
        XCTAssertEqual(result[0].displayName, "Instagram")
        XCTAssertEqual(result[0].duration, 3600)
        XCTAssertEqual(result[0].categoryIdentifier, "SocialNetworking")
        XCTAssertEqual(result[1].bundleIdentifier, "com.apple.mobilesafari")
        XCTAssertNil(result[1].categoryIdentifier)
    }

    func testFetchDailyUsageReturnsEmptyWhenNoPayload() async throws {
        let service = MockableScreenTimeService()
        service.stubbedPayload = nil
        let result = try await service.fetchDailyUsage(for: Date())
        XCTAssertTrue(result.isEmpty)
    }
}

// Subclass seam to inject the payload without hitting App Group container
final class MockableScreenTimeService: ScreenTimeService {
    var stubbedPayload: DailyUsagePayload?

    override func readPayload(for dateString: String) throws -> DailyUsagePayload? {
        stubbedPayload
    }
}
