import Foundation

final class PlaceholderInsightsEngine: InsightsEngineProtocol {
    func generateInsight(from usage: [DailyAppUsage]) async -> String { "" }
    func generateSuggestions(timeSaved: TimeInterval) async -> [String] { [] }
}
