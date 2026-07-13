import Foundation
import Observation

@MainActor
@Observable
final class AppEnvironment {
    let calendarDayService: any CalendarDayProviding
    let unitConverter: any UnitConverting
    let syncCoordinator: any SyncCoordinating
    let now: @Sendable () -> Date

    init(
        calendarDayService: any CalendarDayProviding,
        unitConverter: any UnitConverting,
        syncCoordinator: any SyncCoordinating,
        now: @escaping @Sendable () -> Date
    ) {
        self.calendarDayService = calendarDayService
        self.unitConverter = unitConverter
        self.syncCoordinator = syncCoordinator
        self.now = now
    }

    static let live = AppEnvironment(
        calendarDayService: CalendarDayService(),
        unitConverter: HealthUnitConverter(),
        syncCoordinator: DisabledSyncCoordinator(),
        now: { Date() }
    )

    #if DEBUG
    static let preview = AppEnvironment(
        calendarDayService: CalendarDayService(),
        unitConverter: HealthUnitConverter(),
        syncCoordinator: DisabledSyncCoordinator(),
        now: {
            var components = DateComponents()
            components.calendar = Calendar(identifier: .gregorian)
            components.timeZone = TimeZone(identifier: "America/New_York")
            components.year = 2026
            components.month = 7
            components.day = 14
            components.hour = 8
            return components.date ?? Date(timeIntervalSince1970: 0)
        }
    )
    #endif
}
