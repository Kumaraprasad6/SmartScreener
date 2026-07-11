import FamilyControls
import SwiftUI

struct OnboardingView: View {
    let onAuthorized: () -> Void
    @State private var isRequesting = false
    @State private var authError: String?

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "clock.badge.checkmark.fill")
                .font(.system(size: 72))
                .foregroundStyle(.tint)

            VStack(spacing: 12) {
                Text("ScreenTimeAI")
                    .font(.largeTitle.bold())

                Text("Understand how you spend your time and discover what you could do instead.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
            }

            VStack(spacing: 8) {
                label("Usage data stays on your device", icon: "lock.fill")
                label("No data sent to external servers", icon: "icloud.slash.fill")
                label("You can revoke access anytime in Settings", icon: "gear")
            }
            .padding(.horizontal)

            Spacer()

            VStack(spacing: 12) {
                Button("Grant Screen Time Access") {
                    Task { await requestAuthorization() }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(isRequesting)

                if let authError {
                    Text(authError)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
    }

    private func label(_ text: String, icon: String) -> some View {
        Label(text, systemImage: icon)
            .font(.subheadline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func requestAuthorization() async {
        isRequesting = true
        authError = nil
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            onAuthorized()
        } catch {
            authError = error.localizedDescription
        }
        isRequesting = false
    }
}
