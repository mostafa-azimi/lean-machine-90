import Foundation

struct CalendarDay: Codable, Hashable, Sendable {
    let key: String
    let timeZoneIdentifier: String
    let normalizedDate: Date

    init(date: Date, timeZone: TimeZone, calendarIdentifier: Calendar.Identifier = .gregorian) {
        var calendar = Calendar(identifier: calendarIdentifier)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.timeZone = timeZone

        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let year = components.year ?? 1
        let month = components.month ?? 1
        let day = components.day ?? 1

        key = String(format: "%04d-%02d-%02d", year, month, day)
        timeZoneIdentifier = timeZone.identifier
        normalizedDate = calendar.date(
            from: DateComponents(
                calendar: calendar,
                timeZone: timeZone,
                year: year,
                month: month,
                day: day
            )
        ) ?? date
    }

    func ownerScopedKey(ownerID: UUID) -> String {
        "\(ownerID.uuidString.lowercased()):\(key)"
    }
}

protocol CalendarDayProviding: Sendable {
    func day(for date: Date, in timeZone: TimeZone) -> CalendarDay
}

struct CalendarDayService: CalendarDayProviding {
    func day(for date: Date, in timeZone: TimeZone) -> CalendarDay {
        CalendarDay(date: date, timeZone: timeZone)
    }
}
