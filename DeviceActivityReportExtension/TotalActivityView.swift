import SwiftUI

// Phase 1: replace body with real rendering of activityReport data.
struct TotalActivityView: View {
    let activityReport: ActivityReport

    var body: some View {
        ContentUnavailableView(
            "Collecting data...",
            systemImage: "hourglass",
            description: Text("Usage data will appear here once the pipeline is implemented.")
        )
    }
}
