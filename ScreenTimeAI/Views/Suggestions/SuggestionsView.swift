import SwiftUI

struct SuggestionsView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "No suggestions yet",
                systemImage: "lightbulb.fill",
                description: Text("AI-generated suggestions will appear here based on your usage patterns.")
            )
            .navigationTitle("Suggestions")
        }
    }
}

#Preview {
    SuggestionsView()
}
