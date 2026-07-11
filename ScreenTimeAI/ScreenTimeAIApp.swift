//
//  ScreenTimeAIApp.swift
//  ScreenTimeAI
//
//  Created by T0240U6 on 11/07/26.
//

import SwiftUI
import SwiftData

@main
struct ScreenTimeAIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: DailyAppUsage.self)
    }
}
