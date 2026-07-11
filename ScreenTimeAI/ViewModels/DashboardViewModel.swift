import Foundation
import Observation

@Observable
@MainActor
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
        isLoading = true
        defer { isLoading = false }
        do {
            let today = Date()
            let freshUsage = try await screenTimeService.fetchDailyUsage(for: today)
            if !freshUsage.isEmpty {
                try await persistenceService.save(freshUsage)
            }
            let stored = try await persistenceService.fetchUsage(for: today)
            totalDuration = stored.reduce(0) { $0 + $1.duration }
            topApps = Array(stored.sorted { $0.duration > $1.duration }.prefix(3))
        } catch {
            // Phase 3: surface error state to UI
        }
    }
}
