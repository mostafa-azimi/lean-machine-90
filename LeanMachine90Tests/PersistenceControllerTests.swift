import SwiftData
import XCTest
@testable import LeanMachine90

final class PersistenceControllerTests: XCTestCase {
    @MainActor
    func testVersionOneSchemaCreatesInMemoryContainer() throws {
        let container = try PersistenceController.makeContainer(inMemory: true)
        let context = container.mainContext
        let ownerID = UUID()
        let profile = UserProfile(ownerID: ownerID)

        context.insert(profile)
        try context.save()

        let profiles = try context.fetch(FetchDescriptor<UserProfile>())
        XCTAssertEqual(profiles.map(\.ownerID), [ownerID])
    }

    @MainActor
    func testDailyRecordsUseSameUniqueKeyForSameOwnerAndDay() throws {
        let date = try XCTUnwrap(
            ISO8601DateFormatter().date(from: "2026-07-14T12:00:00Z")
        )
        let day = CalendarDay(
            date: date,
            timeZone: try XCTUnwrap(TimeZone(identifier: "America/New_York"))
        )
        let ownerID = UUID()
        let goalPlanID = UUID()
        let first = DailyLog(ownerID: ownerID, goalPlanID: goalPlanID, calendarDay: day)
        let duplicate = DailyLog(ownerID: ownerID, goalPlanID: goalPlanID, calendarDay: day)

        XCTAssertEqual(first.recordKey, duplicate.recordKey)
    }
}
