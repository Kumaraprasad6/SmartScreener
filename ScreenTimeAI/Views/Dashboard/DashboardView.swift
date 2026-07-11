import DeviceActivity
import SwiftUI

struct DashboardView: View {
    let viewModel: DashboardViewModel

    private var todayFilter: DeviceActivityFilter {
        let calendar = Calendar.current
        let now = Date()
        let start = calendar.startOfDay(for: now)
        let end = calendar.date(byAdding: .day, value: 1, to: start) ?? now
        return DeviceActivityFilter(
            segment: .daily(during: DateInterval(start: start, end: end)),
            users: .all,
            devices: .init([.iPhone])
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    totalDurationCard
                    DeviceActivityReport(.totalActivity, filter: todayFilter)
                    topAppsCard
                }
                .padding()
            }
            .navigationTitle("Today")
            .task { await viewModel.loadToday() }
        }
    }

    private var totalDurationCard: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Total Screen Time")
                .font(.caption)
                .foregroundStyle(.secondary)
            if viewModel.isLoading {
                ProgressView()
            } else {
                Text(viewModel.totalDuration.screenTimeFormatted)
                    .font(.largeTitle.bold())
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var topAppsCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Top Apps")
                .font(.headline)
            if viewModel.topApps.isEmpty {
                Text("No data yet")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.topApps, id: \.bundleIdentifier) { app in
                    HStack {
                        Text(app.displayName)
                        Spacer()
                        Text(app.duration.screenTimeFormatted)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
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
