import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Screen Time") {
                    Label("Permission not yet configured", systemImage: "lock.fill")
                        .foregroundStyle(.secondary)
                }
                Section("Account") {
                    Label("Sync not yet configured", systemImage: "icloud.fill")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
