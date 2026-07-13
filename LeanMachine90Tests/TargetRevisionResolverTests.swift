import XCTest
@testable import LeanMachine90

final class TargetRevisionResolverTests: XCTestCase {
    func testSelectsLatestRevisionEffectiveOnRequestedDay() {
        let initial = revision(
            dayKey: "2026-07-14",
            createdAt: Date(timeIntervalSince1970: 1),
            calories: 2_250
        )
        let later = revision(
            dayKey: "2026-07-21",
            createdAt: Date(timeIntervalSince1970: 2),
            calories: 2_150
        )

        XCTAssertEqual(
            TargetRevisionResolver.effectiveRevision(
                on: "2026-07-20",
                from: [later, initial]
            )?.dailyCaloriesTarget,
            2_250
        )
        XCTAssertEqual(
            TargetRevisionResolver.effectiveRevision(
                on: "2026-07-21",
                from: [initial, later]
            )?.dailyCaloriesTarget,
            2_150
        )
    }

    func testLatestSameDayRevisionWinsWithoutErasingHistory() {
        let first = revision(
            dayKey: "2026-07-21",
            createdAt: Date(timeIntervalSince1970: 1),
            calories: 2_150
        )
        let corrected = revision(
            dayKey: "2026-07-21",
            createdAt: Date(timeIntervalSince1970: 2),
            calories: 2_200
        )

        XCTAssertEqual(
            TargetRevisionResolver.effectiveRevision(
                on: "2026-07-21",
                from: [corrected, first]
            )?.dailyCaloriesTarget,
            2_200
        )
    }

    func testReturnsNilBeforeFirstRevision() {
        let initial = revision(
            dayKey: "2026-07-14",
            createdAt: Date(timeIntervalSince1970: 1),
            calories: 2_250
        )

        XCTAssertNil(
            TargetRevisionResolver.effectiveRevision(
                on: "2026-07-13",
                from: [initial]
            )
        )
    }

    func testDayPlanCopiesTargetsIntoStableSnapshot() throws {
        let revision = revision(
            dayKey: "2026-07-14",
            createdAt: Date(timeIntervalSince1970: 1),
            calories: 2_250
        )
        let date = try XCTUnwrap(
            ISO8601DateFormatter().date(from: "2026-07-14T12:00:00Z")
        )
        let day = CalendarDay(
            date: date,
            timeZone: try XCTUnwrap(TimeZone(identifier: "America/New_York"))
        )
        let plan = DayPlan(
            ownerID: UUID(),
            goalPlanID: UUID(),
            calendarDay: day,
            targetRevision: revision
        )

        XCTAssertEqual(plan.caloriesTarget, 2_250)
        XCTAssertEqual(plan.proteinGramsTarget, 200)
        XCTAssertEqual(plan.stepTarget, 7_000)
        XCTAssertEqual(plan.targetRevisionID, revision.id)
    }

    private func revision(
        dayKey: String,
        createdAt: Date,
        calories: Int
    ) -> TargetRevisionDescriptor {
        TargetRevisionDescriptor(
            id: UUID(),
            effectiveDayKey: dayKey,
            createdAt: createdAt,
            dailyCaloriesTarget: calories,
            dailyProteinGrams: 200,
            dailyCarbohydrateGrams: 205,
            dailyFatGrams: 70,
            dailyWaterMilliliters: 2_957,
            dailySleepMinutes: 480,
            alcoholTarget: 0,
            dailyStepTarget: 7_000
        )
    }
}
