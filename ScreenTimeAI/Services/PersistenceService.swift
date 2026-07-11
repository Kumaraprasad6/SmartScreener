import Foundation
import SwiftData

final class PersistenceService: PersistenceServiceProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func save(_ usage: [DailyAppUsage]) async throws {
        for item in usage {
            modelContext.insert(item)
        }
        try modelContext.save()
    }

    func fetchUsage(for date: Date) async throws -> [DailyAppUsage] {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(byAdding: .day, value: 1, to: start) ?? date
        return try fetch(from: start, to: end)
    }

    func fetchUsage(for interval: DateInterval) async throws -> [DailyAppUsage] {
        try fetch(from: interval.start, to: interval.end)
    }

    func fetchAllDates() async throws -> [Date] {
        let descriptor = FetchDescriptor<DailyAppUsage>()
        let all = try modelContext.fetch(descriptor)
        let unique = Set(all.map { Calendar.current.startOfDay(for: $0.date) })
        return unique.sorted()
    }

    private func fetch(from start: Date, to end: Date) throws -> [DailyAppUsage] {
        let predicate = #Predicate<DailyAppUsage> { usage in
            usage.date >= start && usage.date < end
        }
        let descriptor = FetchDescriptor<DailyAppUsage>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.duration, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
}
