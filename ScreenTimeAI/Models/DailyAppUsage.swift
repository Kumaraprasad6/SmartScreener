import Foundation
import SwiftData

@Model
final class DailyAppUsage {
    var bundleIdentifier: String
    var displayName: String
    var duration: TimeInterval
    var date: Date
    var categoryIdentifier: String?

    init(
        bundleIdentifier: String,
        displayName: String,
        duration: TimeInterval,
        date: Date,
        categoryIdentifier: String? = nil
    ) {
        self.bundleIdentifier = bundleIdentifier
        self.displayName = displayName
        self.duration = duration
        self.date = date
        self.categoryIdentifier = categoryIdentifier
    }
}
