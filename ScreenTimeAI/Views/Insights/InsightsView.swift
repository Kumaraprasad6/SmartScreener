import SwiftUI

struct InsightsView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "No data yet",
                systemImage: "chart.bar.fill",
                description: Text("Weekly and monthly trends will appear as your history builds up.")
            )
            .navigationTitle("Insights")
        }
    }
}

#Preview {
    InsightsView()
}
