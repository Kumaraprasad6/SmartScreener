import Foundation
import Observation

@Observable
final class DashboardViewModel {
    var totalDuration: TimeInterval = 0
    var topApps: [DailyAppUsage] = []
    var aiInsight: String = ""
    var isLoading: Bool = false

    private let screenTimeService: any ScreenTimeServiceProtocol
    private let persistenceService: any PersistenceServiceProtocol
    private let insightsEngine: any InsightsEngineProtocol

    init(
        screenTimeService: some ScreenTimeServiceProtocol,
        persistenceService: some PersistenceServiceProtocol,
        insightsEngine: some InsightsEngineProtocol
    ) {
        self.screenTimeService = screenTimeService
        self.persistenceService = persistenceService
        self.insightsEngine = insightsEngine
    }

    func loadToday() async {
        // Phase 1: implement real data fetch
    }
}
