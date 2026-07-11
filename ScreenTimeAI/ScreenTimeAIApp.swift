import SwiftData
import SwiftUI

@main
struct ScreenTimeAIApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: DailyAppUsage.self)
    }
}

struct RootView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ContentView(
            screenTimeService: ScreenTimeService(),
            persistenceService: PersistenceService(modelContext: modelContext)
        )
    }
}
