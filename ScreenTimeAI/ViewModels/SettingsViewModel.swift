import Foundation
import Observation

@Observable
final class SettingsViewModel {
    var isScreenTimeAuthorized: Bool = false
    var isSyncEnabled: Bool = false
    var isSignedIn: Bool = false

    private let screenTimeService: any ScreenTimeServiceProtocol
    private let syncService: any SyncServiceProtocol

    init(
        screenTimeService: some ScreenTimeServiceProtocol,
        syncService: some SyncServiceProtocol
    ) {
        self.screenTimeService = screenTimeService
        self.syncService = syncService
    }

    func requestScreenTimePermission() async {
        // Phase 1: wire up FamilyControls authorization
    }

    func signOut() async {
        // Phase 5: implement sign-out via SyncService
    }
}
