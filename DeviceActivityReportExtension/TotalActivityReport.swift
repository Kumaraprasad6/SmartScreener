import DeviceActivity
import Foundation
import SwiftUI

extension DeviceActivityReport.Context {
    static let totalActivity = Self("TotalActivity")
}

struct ActivityReport {
    let apps: [AppUsageEntry]
    var totalDuration: TimeInterval { apps.reduce(0) { $0 + $1.duration } }
}

struct TotalActivityReport: DeviceActivityReportScene {
    let context: DeviceActivityReport.Context = .totalActivity
    let content: (ActivityReport) -> TotalActivityView

    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> ActivityReport {
        var entryDict: [String: AppUsageEntry] = [:]

        for await activityData in data {
            for await segment in activityData.activitySegments {
                for await categoryActivity in segment.categories {
                    let categoryName = categoryActivity.category.localizedDisplayName
                    for await appActivity in categoryActivity.applications {
                        let bundleId = appActivity.application.bundleIdentifier ?? "unknown"
                        let duration = appActivity.totalActivityDuration

                        if let existing = entryDict[bundleId] {
                            let mergedEntry = AppUsageEntry(
                                bundleIdentifier: existing.bundleIdentifier,
                                displayName: existing.displayName,
                                duration: existing.duration + duration,
                                categoryIdentifier: existing.categoryIdentifier
                            )
                            entryDict[bundleId] = mergedEntry
                        } else {
                            let entry = AppUsageEntry(
                                bundleIdentifier: bundleId,
                                displayName: appActivity.application.localizedDisplayName ?? "Unknown",
                                duration: duration,
                                categoryIdentifier: categoryName
                            )
                            entryDict[bundleId] = entry
                        }
                    }
                }
            }
        }

        let entries = entryDict.values.sorted { $0.duration > $1.duration }

        let payload = DailyUsagePayload(
            date: DateFormatter.isoDate.string(from: Date()),
            apps: entries
        )
        try? AppGroupStore.write(payload)

        return ActivityReport(apps: entries)
    }
}
