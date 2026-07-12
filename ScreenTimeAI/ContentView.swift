import FamilyControls
import SwiftUI

struct ContentView: View {
    let screenTimeService: any ScreenTimeServiceProtocol
    let persistenceService: any PersistenceServiceProtocol

    @State private var isAuthorized: Bool
    @State private var viewModel: DashboardViewModel

    init(
        screenTimeService: some ScreenTimeServiceProtocol,
        persistenceService: some PersistenceServiceProtocol
    ) {
        self.screenTimeService = screenTimeService
        self.persistenceService = persistenceService
        _isAuthorized = State(initialValue: AuthorizationCenter.shared.authorizationStatus == .approved)
        _viewModel = State(initialValue: DashboardViewModel(
            screenTimeService: screenTimeService,
            persistenceService: persistenceService,
            insightsEngine: PlaceholderInsightsEngine()
        ))
    }

    var body: some View {
        if isAuthorized {
            mainTabView
        } else {
            OnboardingView { isAuthorized = true }
        }
    }

    private var mainTabView: some View {
        TabView {
            DashboardView(viewModel: viewModel)
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
}
