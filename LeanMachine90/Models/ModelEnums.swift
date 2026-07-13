import Foundation

enum UnitSystem: String, Codable, CaseIterable, Sendable {
    case us
    case metric
}

enum UCStatus: String, Codable, CaseIterable, Sendable {
    case normal
    case mildSymptoms
    case moderateFlare
    case severeFlare
}

enum CompletionStatus: String, Codable, CaseIterable, Sendable {
    case pending
    case complete
    case skipped
    case notApplicable
}

enum RecordDataSource: String, Codable, CaseIterable, Sendable {
    case manual
    case healthKit
    case imported
}

enum SyncState: String, Codable, CaseIterable, Sendable {
    case localOnly
    case pending
    case synced
    case conflict
}

enum SyncOperationKind: String, Codable, CaseIterable, Sendable {
    case create
    case update
    case delete
}

enum SyncEntityType: String, Codable, CaseIterable, Sendable {
    case userProfile
    case goalPlan
    case targetRevision
    case dayPlan
    case dailyLog
    case appSettings
}
