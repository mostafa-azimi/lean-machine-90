import XCTest
@testable import LeanMachine90

final class CalendarDayTests: XCTestCase {
    private let service = CalendarDayService()

    func testSameInstantCanBelongToDifferentLocalDays() throws {
        let instant = try XCTUnwrap(
            ISO8601DateFormatter().date(from: "2026-07-14T02:00:00Z")
        )
        let newYork = try XCTUnwrap(TimeZone(identifier: "America/New_York"))
        let tokyo = try XCTUnwrap(TimeZone(identifier: "Asia/Tokyo"))

        XCTAssertEqual(service.day(for: instant, in: newYork).key, "2026-07-13")
        XCTAssertEqual(service.day(for: instant, in: tokyo).key, "2026-07-14")
    }

    func testSpringForwardTimesRetainTheSameCalendarDay() throws {
        let beforeJump = try XCTUnwrap(
            ISO8601DateFormatter().date(from: "2026-03-08T06:30:00Z")
        )
        let afterJump = try XCTUnwrap(
            ISO8601DateFormatter().date(from: "2026-03-08T07:30:00Z")
        )
        let newYork = try XCTUnwrap(TimeZone(identifier: "America/New_York"))

        XCTAssertEqual(service.day(for: beforeJump, in: newYork).key, "2026-03-08")
        XCTAssertEqual(service.day(for: afterJump, in: newYork).key, "2026-03-08")
    }

    func testRecordKeyIsOwnerScoped() throws {
        let date = try XCTUnwrap(
            ISO8601DateFormatter().date(from: "2026-07-14T12:00:00Z")
        )
        let day = service.day(for: date, in: try XCTUnwrap(TimeZone(identifier: "UTC")))
        let firstOwner = UUID()
        let secondOwner = UUID()

        XCTAssertEqual(day.ownerScopedKey(ownerID: firstOwner), day.ownerScopedKey(ownerID: firstOwner))
        XCTAssertNotEqual(day.ownerScopedKey(ownerID: firstOwner), day.ownerScopedKey(ownerID: secondOwner))
    }
}
