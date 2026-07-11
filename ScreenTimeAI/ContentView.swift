//
//  ContentView.swift
//  ScreenTimeAI
//
//  Created by T0240U6 on 11/07/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
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

#Preview {
    ContentView()
}
