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
    @State private var screenTimeService = ScreenTimeService()

    var body: some View {
        ContentView(
            screenTimeService: screenTimeService,
            persistenceService: PersistenceService(modelContext: modelContext)
        )
    }
}
