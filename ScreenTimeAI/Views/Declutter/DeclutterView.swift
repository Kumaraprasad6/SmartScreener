import SwiftUI

struct DeclutterView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "Nothing to declutter yet",
                systemImage: "trash.fill",
                description: Text("Rarely used apps will appear here once enough history has been collected.")
            )
            .navigationTitle("Declutter")
        }
    }
}

#Preview {
    DeclutterView()
}
