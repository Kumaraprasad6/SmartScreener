import Foundation
import Observation

@Observable
final class DeclutterViewModel {
    var unusedApps: [DailyAppUsage] = []
    var isLoading: Bool = false

    private let persistenceService: any PersistenceServiceProtocol

    init(persistenceService: some PersistenceServiceProtocol) {
        self.persistenceService = persistenceService
    }

    func load() async {
        // Phase 4: surface lowest-usage apps
    }
}
