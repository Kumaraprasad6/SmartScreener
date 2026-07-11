import Foundation
import Observation

@Observable
final class TopAppsViewModel {
    enum Period { case day, week, month }

    var selectedPeriod: Period = .week
    var rankedApps: [DailyAppUsage] = []
    var isLoading: Bool = false

    private let persistenceService: any PersistenceServiceProtocol

    init(persistenceService: some PersistenceServiceProtocol) {
        self.persistenceService = persistenceService
    }

    func load() async {
        // Phase 2: implement ranked fetch and aggregation
    }
}
