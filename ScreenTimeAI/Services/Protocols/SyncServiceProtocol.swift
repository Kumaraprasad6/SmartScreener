import Foundation

protocol SyncServiceProtocol {
    var isSignedIn: Bool { get }
    func signIn() async throws
    func signOut() async throws
    func syncUsage(_ usage: [DailyAppUsage]) async throws
    func fetchRemoteHistory() async throws -> [DailyAppUsage]
}
