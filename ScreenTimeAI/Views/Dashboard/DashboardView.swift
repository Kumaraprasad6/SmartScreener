import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "Building your history...",
                systemImage: "clock.fill",
                description: Text("Screen Time data will appear here once the pipeline is live.")
            )
            .navigationTitle("Today")
        }
    }
}

#Preview {
    DashboardView()
}
