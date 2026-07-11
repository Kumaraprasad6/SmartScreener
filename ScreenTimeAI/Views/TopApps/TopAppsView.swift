import SwiftUI

struct TopAppsView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "No data yet",
                systemImage: "list.number",
                description: Text("Your most-used apps will be ranked here.")
            )
            .navigationTitle("Top Apps")
        }
    }
}

#Preview {
    TopAppsView()
}
