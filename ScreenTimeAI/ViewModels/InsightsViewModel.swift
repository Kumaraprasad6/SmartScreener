import Foundation
import Observation

@Observable
final class InsightsViewModel {
    var weeklyUsage: [DailyAppUsage] = []
    var dailyAverage: TimeInterval = 0
    var weekOverWeekDelta: Double = 0
    var isLoading: Bool = false

    private let persistenceService: any PersistenceServiceProtocol

    init(persistenceService: some PersistenceServiceProtocol) {
        self.persistenceService = persistenceService
    }

    func loadInsights() async {
        // Phase 2: implement stats computation
    }
}
