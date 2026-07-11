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
        var entries: [AppUsageEntry] = []

        for await activityData in data {
            for await segment in activityData.activitySegments {
                for await categoryActivity in segment.categories {
                    let categoryName = categoryActivity.category.localizedDisplayName
                    for await appActivity in categoryActivity.applications {
                        let entry = AppUsageEntry(
                            bundleIdentifier: appActivity.application.bundleIdentifier ?? "unknown",
                            displayName: appActivity.application.localizedDisplayName ?? "Unknown",
                            duration: appActivity.totalActivityDuration,
                            categoryIdentifier: categoryName
                        )
                        entries.append(entry)
                    }
                }
            }
        }

        let payload = DailyUsagePayload(
            date: DateFormatter.isoDate.string(from: Date()),
            apps: entries
        )
        try? AppGroupStore.write(payload)

        return ActivityReport(apps: entries.sorted { $0.duration > $1.duration })
    }
}
