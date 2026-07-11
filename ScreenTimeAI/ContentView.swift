import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            DashboardView(viewModel: makeDashboardViewModel())
                .tabItem { Label("Today", systemImage: "clock.fill") }

            InsightsView()
                .tabItem { Label("Insights", systemImage: "chart.bar.fill") }

            TopAppsView()
                .tabItem { Label("Top Apps", systemImage: "list.number") }

            DeclutterView()
                .tabItem { Label("Declutter", systemImage: "trash.fill") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear") }
        }
    }

    private func makeDashboardViewModel() -> DashboardViewModel {
        DashboardViewModel(
            screenTimeService: ScreenTimeService(),
            persistenceService: PersistenceService(modelContext: modelContext),
            insightsEngine: StubInsightsEngine()
        )
    }
}

private struct StubInsightsEngine: InsightsEngineProtocol {
    func generateInsight(from usage: [DailyAppUsage]) async -> String { "" }
    func generateSuggestions(timeSaved: TimeInterval) async -> [String] { [] }
}

#Preview {
    ContentView()
        .modelContainer(for: DailyAppUsage.self, inMemory: true)
}
