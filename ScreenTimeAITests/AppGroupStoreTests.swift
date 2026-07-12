import XCTest
@testable import ScreenTimeAI

final class AppGroupStoreTests: XCTestCase {

    func testPayloadEncodeDecode() throws {
        let entry = AppUsageEntry(
            bundleIdentifier: "com.instagram.Instagram",
            displayName: "Instagram",
            duration: 3600,
            categoryIdentifier: "SocialNetworking"
        )
        let payload = DailyUsagePayload(date: "2026-07-11", apps: [entry])

        let data = try JSONEncoder().encode(payload)
        let decoded = try JSONDecoder().decode(DailyUsagePayload.self, from: data)

        XCTAssertEqual(decoded.date, "2026-07-11")
        XCTAssertEqual(decoded.apps.count, 1)
        XCTAssertEqual(decoded.apps[0].bundleIdentifier, "com.instagram.Instagram")
        XCTAssertEqual(decoded.apps[0].displayName, "Instagram")
        XCTAssertEqual(decoded.apps[0].duration, 3600)
        XCTAssertEqual(decoded.apps[0].categoryIdentifier, "SocialNetworking")
    }

    func testPayloadNilCategoryIdentifier() throws {
        let entry = AppUsageEntry(
            bundleIdentifier: "com.apple.mobilemail",
            displayName: "Mail",
            duration: 120,
            categoryIdentifier: nil
        )
        let payload = DailyUsagePayload(date: "2026-07-11", apps: [entry])

        let data = try JSONEncoder().encode(payload)
        let decoded = try JSONDecoder().decode(DailyUsagePayload.self, from: data)

        XCTAssertNil(decoded.apps[0].categoryIdentifier)
    }

    func testIsoDateFormatterFormat() {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = 2026; components.month = 7; components.day = 11
        let date = calendar.date(from: components)!
        XCTAssertEqual(DateFormatter.isoDate.string(from: date), "2026-07-11")
    }
}
