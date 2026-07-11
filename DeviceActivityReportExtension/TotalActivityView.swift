import SwiftUI

struct TotalActivityView: View {
    let activityReport: ActivityReport

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if activityReport.apps.isEmpty {
                ContentUnavailableView(
                    "No usage today",
                    systemImage: "checkmark.seal.fill",
                    description: Text("No screen time recorded yet today.")
                )
            } else {
                ForEach(activityReport.apps, id: \.bundleIdentifier) { app in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(app.displayName)
                                .font(.subheadline)
                            if let category = app.categoryIdentifier {
                                Text(category)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                        Text(app.duration.screenTimeFormatted)
                            .font(.subheadline.monospacedDigit())
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                    Divider()
                }
            }
        }
        .padding(.horizontal)
    }
}

private extension TimeInterval {
    var screenTimeFormatted: String {
        let hours = Int(self) / 3600
        let minutes = (Int(self) % 3600) / 60
        if hours > 0 { return "\(hours)h \(minutes)m" }
        if minutes > 0 { return "\(minutes)m" }
        return "<1m"
    }
}
