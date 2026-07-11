import Foundation
import Observation

@Observable
final class SuggestionsViewModel {
    var suggestions: [String] = []
    var timeSaved: TimeInterval = 0
    var isLoading: Bool = false

    private let insightsEngine: any InsightsEngineProtocol
    private let persistenceService: any PersistenceServiceProtocol

    init(
        insightsEngine: some InsightsEngineProtocol,
        persistenceService: some PersistenceServiceProtocol
    ) {
        self.insightsEngine = insightsEngine
        self.persistenceService = persistenceService
    }

    func loadSuggestions() async {
        // Phase 3: generate on-device AI suggestions
    }
}
