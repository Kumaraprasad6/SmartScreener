import DeviceActivity
import Foundation
import SwiftUI

// Phase 1: define the report context key used by the main app
// when requesting usage data via DeviceActivityReport.
extension DeviceActivityReport.Context {
    static let totalActivity = Self("TotalActivity")
}

// Phase 1: populate with real aggregated per-app durations.
struct ActivityReport {
    var appUsages: [String: TimeInterval] = [:]
}

// Phase 1: replace makeConfiguration body with real aggregation —
// compute per-app durations from DeviceActivityResults and
// write them to the App Group container for the main app.
struct TotalActivityReport: DeviceActivityReportScene {
    let context: DeviceActivityReport.Context = .totalActivity
    let content: (ActivityReport) -> TotalActivityView

    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> ActivityReport {
        ActivityReport()
    }
}
