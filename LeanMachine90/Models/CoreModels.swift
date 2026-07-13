import Foundation
import SwiftData

@Model
final class UserProfile {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var ownerID: UUID
    var createdAt: Date
    var updatedAt: Date
    var age: Int?
    var sex: String?
    var heightCentimeters: Double?
    var preferredUnitSystemRaw: String
    var goalDescription: String
    var motivation: String
    var healthDisclaimerAcknowledgedAt: Date?
    var healthNotes: String?
    var serverRevision: Int64?
    var lastSyncedAt: Date?
    var syncStateRaw: String
    var deletedAt: Date?

    init(
        id: UUID = UUID(),
        ownerID: UUID,
        createdAt: Date = Date(),
        age: Int? = nil,
        sex: String? = nil,
        heightCentimeters: Double? = nil,
        preferredUnitSystem: UnitSystem = .us,
        goalDescription: String = "",
        motivation: String = "",
        healthDisclaimerAcknowledgedAt: Date? = nil,
        healthNotes: String? = nil
    ) {
        self.id = id
        self.ownerID = ownerID
        self.createdAt = createdAt
        updatedAt = createdAt
        self.age = age
        self.sex = sex
        self.heightCentimeters = heightCentimeters
        preferredUnitSystemRaw = preferredUnitSystem.rawValue
        self.goalDescription = goalDescription
        self.motivation = motivation
        self.healthDisclaimerAcknowledgedAt = healthDisclaimerAcknowledgedAt
        self.healthNotes = healthNotes
        syncStateRaw = SyncState.localOnly.rawValue
    }

    var preferredUnitSystem: UnitSystem {
        get { UnitSystem(rawValue: preferredUnitSystemRaw) ?? .us }
        set { preferredUnitSystemRaw = newValue.rawValue }
    }

    var syncState: SyncState {
        get { SyncState(rawValue: syncStateRaw) ?? .localOnly }
        set { syncStateRaw = newValue.rawValue }
    }
}

@Model
final class GoalPlan {
    @Attribute(.unique) var id: UUID
    var ownerID: UUID
    var profileID: UUID
    var createdAt: Date
    var updatedAt: Date
    var startDate: Date
    var startDayKey: String
    var phaseLengthDays: Int
    var extendedHorizonDays: Int
    var startingWeightKilograms: Double?
    var targetWeightKilograms: Double?
    var weeklyReviewWeekday: Int
    var isActive: Bool
    var serverRevision: Int64?
    var lastSyncedAt: Date?
    var syncStateRaw: String
    var deletedAt: Date?

    init(
        id: UUID = UUID(),
        ownerID: UUID,
        profileID: UUID,
        startDate: Date,
        calendarDay: CalendarDay,
        phaseLengthDays: Int = 90,
        extendedHorizonDays: Int = 180,
        startingWeightKilograms: Double? = nil,
        targetWeightKilograms: Double? = nil,
        weeklyReviewWeekday: Int = 1,
        isActive: Bool = true,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.ownerID = ownerID
        self.profileID = profileID
        self.createdAt = createdAt
        updatedAt = createdAt
        self.startDate = startDate
        startDayKey = calendarDay.key
        self.phaseLengthDays = phaseLengthDays
        self.extendedHorizonDays = extendedHorizonDays
        self.startingWeightKilograms = startingWeightKilograms
        self.targetWeightKilograms = targetWeightKilograms
        self.weeklyReviewWeekday = weeklyReviewWeekday
        self.isActive = isActive
        syncStateRaw = SyncState.localOnly.rawValue
    }
}

@Model
final class TargetRevision {
    @Attribute(.unique) var id: UUID
    var ownerID: UUID
    var goalPlanID: UUID
    var effectiveDayKey: String
    var createdAt: Date
    var dailyCaloriesTarget: Int
    var dailyProteinGrams: Int
    var dailyCarbohydrateGrams: Int
    var dailyFatGrams: Int
    var dailyWaterMilliliters: Int
    var dailySleepMinutes: Int
    var alcoholTarget: Int
    var dailyStepTarget: Int
    var reason: String
    var sourceRaw: String
    var replacesRevisionID: UUID?
    var serverRevision: Int64?
    var lastSyncedAt: Date?
    var syncStateRaw: String
    var deletedAt: Date?

    init(
        id: UUID = UUID(),
        ownerID: UUID,
        goalPlanID: UUID,
        effectiveDayKey: String,
        dailyCaloriesTarget: Int,
        dailyProteinGrams: Int,
        dailyCarbohydrateGrams: Int,
        dailyFatGrams: Int,
        dailyWaterMilliliters: Int,
        dailySleepMinutes: Int,
        alcoholTarget: Int,
        dailyStepTarget: Int,
        reason: String,
        source: TargetRevisionSource,
        replacesRevisionID: UUID? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.ownerID = ownerID
        self.goalPlanID = goalPlanID
        self.effectiveDayKey = effectiveDayKey
        self.createdAt = createdAt
        self.dailyCaloriesTarget = dailyCaloriesTarget
        self.dailyProteinGrams = dailyProteinGrams
        self.dailyCarbohydrateGrams = dailyCarbohydrateGrams
        self.dailyFatGrams = dailyFatGrams
        self.dailyWaterMilliliters = dailyWaterMilliliters
        self.dailySleepMinutes = dailySleepMinutes
        self.alcoholTarget = alcoholTarget
        self.dailyStepTarget = dailyStepTarget
        self.reason = reason
        sourceRaw = source.rawValue
        self.replacesRevisionID = replacesRevisionID
        syncStateRaw = SyncState.localOnly.rawValue
    }

    var descriptor: TargetRevisionDescriptor {
        TargetRevisionDescriptor(
            id: id,
            effectiveDayKey: effectiveDayKey,
            createdAt: createdAt,
            dailyCaloriesTarget: dailyCaloriesTarget,
            dailyProteinGrams: dailyProteinGrams,
            dailyCarbohydrateGrams: dailyCarbohydrateGrams,
            dailyFatGrams: dailyFatGrams,
            dailyWaterMilliliters: dailyWaterMilliliters,
            dailySleepMinutes: dailySleepMinutes,
            alcoholTarget: alcoholTarget,
            dailyStepTarget: dailyStepTarget
        )
    }
}

enum TargetRevisionSource: String, Codable, CaseIterable, Sendable {
    case initial
    case userEdit
    case weeklySuggestion
    case undo
}

struct TargetRevisionDescriptor: Equatable, Sendable {
    let id: UUID
    let effectiveDayKey: String
    let createdAt: Date
    let dailyCaloriesTarget: Int
    let dailyProteinGrams: Int
    let dailyCarbohydrateGrams: Int
    let dailyFatGrams: Int
    let dailyWaterMilliliters: Int
    let dailySleepMinutes: Int
    let alcoholTarget: Int
    let dailyStepTarget: Int
}

enum TargetRevisionResolver {
    static func effectiveRevision(
        on dayKey: String,
        from revisions: [TargetRevisionDescriptor]
    ) -> TargetRevisionDescriptor? {
        revisions
            .filter { $0.effectiveDayKey <= dayKey }
            .max {
                if $0.effectiveDayKey == $1.effectiveDayKey {
                    return $0.createdAt < $1.createdAt
                }
                return $0.effectiveDayKey < $1.effectiveDayKey
            }
    }
}

@Model
final class DayPlan {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var recordKey: String
    var ownerID: UUID
    var goalPlanID: UUID
    var targetRevisionID: UUID
    var dayKey: String
    var timeZoneIdentifier: String
    var normalizedDate: Date
    var caloriesTarget: Int
    var proteinGramsTarget: Int
    var carbohydrateGramsTarget: Int
    var fatGramsTarget: Int
    var waterMillilitersTarget: Int
    var sleepMinutesTarget: Int
    var alcoholTarget: Int
    var stepTarget: Int
    var plannedWorkoutTemplateID: UUID?
    var photoScheduled: Bool
    var measurementScheduled: Bool
    var travelMode: Bool
    var recoveryDay: Bool
    var focusText: String
    var generatedAt: Date
    var userEditedAt: Date?
    var serverRevision: Int64?
    var lastSyncedAt: Date?
    var syncStateRaw: String
    var deletedAt: Date?

    init(
        id: UUID = UUID(),
        ownerID: UUID,
        goalPlanID: UUID,
        calendarDay: CalendarDay,
        targetRevision: TargetRevisionDescriptor,
        generatedAt: Date = Date()
    ) {
        self.id = id
        recordKey = calendarDay.ownerScopedKey(ownerID: ownerID)
        self.ownerID = ownerID
        self.goalPlanID = goalPlanID
        targetRevisionID = targetRevision.id
        dayKey = calendarDay.key
        timeZoneIdentifier = calendarDay.timeZoneIdentifier
        normalizedDate = calendarDay.normalizedDate
        caloriesTarget = targetRevision.dailyCaloriesTarget
        proteinGramsTarget = targetRevision.dailyProteinGrams
        carbohydrateGramsTarget = targetRevision.dailyCarbohydrateGrams
        fatGramsTarget = targetRevision.dailyFatGrams
        waterMillilitersTarget = targetRevision.dailyWaterMilliliters
        sleepMinutesTarget = targetRevision.dailySleepMinutes
        alcoholTarget = targetRevision.alcoholTarget
        stepTarget = targetRevision.dailyStepTarget
        photoScheduled = false
        measurementScheduled = false
        travelMode = false
        recoveryDay = false
        focusText = ""
        self.generatedAt = generatedAt
        syncStateRaw = SyncState.localOnly.rawValue
    }
}

@Model
final class DailyLog {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var recordKey: String
    var ownerID: UUID
    var goalPlanID: UUID
    var dayKey: String
    var timeZoneIdentifier: String
    var normalizedDate: Date
    var createdAt: Date
    var updatedAt: Date
    var morningStatusRaw: String
    var eveningStatusRaw: String
    var morningWeightKilograms: Double?
    var weightSourceRaw: String?
    var sleepMinutes: Int?
    var recoveryScore: Int?
    var restingHeartRate: Int?
    var hrvMilliseconds: Double?
    var energyMorning: Int?
    var hungerMorning: Int?
    var stress: Int?
    var ucStatusRaw: String?
    var painFlag: Bool
    var calories: Int?
    var proteinGrams: Double?
    var carbohydrateGrams: Double?
    var fatGrams: Double?
    var waterMilliliters: Int?
    var alcoholDrinks: Double?
    var steps: Int?
    var hungerEvening: Int?
    var energyEvening: Int?
    var winText: String
    var improvementText: String
    var tomorrowObstacle: String
    var tomorrowFirstAction: String
    var notes: String
    var serverRevision: Int64?
    var lastSyncedAt: Date?
    var syncStateRaw: String
    var deletedAt: Date?

    init(
        id: UUID = UUID(),
        ownerID: UUID,
        goalPlanID: UUID,
        calendarDay: CalendarDay,
        createdAt: Date = Date()
    ) {
        self.id = id
        recordKey = calendarDay.ownerScopedKey(ownerID: ownerID)
        self.ownerID = ownerID
        self.goalPlanID = goalPlanID
        dayKey = calendarDay.key
        timeZoneIdentifier = calendarDay.timeZoneIdentifier
        normalizedDate = calendarDay.normalizedDate
        self.createdAt = createdAt
        updatedAt = createdAt
        morningStatusRaw = CompletionStatus.pending.rawValue
        eveningStatusRaw = CompletionStatus.pending.rawValue
        painFlag = false
        winText = ""
        improvementText = ""
        tomorrowObstacle = ""
        tomorrowFirstAction = ""
        notes = ""
        syncStateRaw = SyncState.localOnly.rawValue
    }

    var morningStatus: CompletionStatus {
        get { CompletionStatus(rawValue: morningStatusRaw) ?? .pending }
        set { morningStatusRaw = newValue.rawValue }
    }

    var eveningStatus: CompletionStatus {
        get { CompletionStatus(rawValue: eveningStatusRaw) ?? .pending }
        set { eveningStatusRaw = newValue.rawValue }
    }

    var ucStatus: UCStatus? {
        get { ucStatusRaw.flatMap(UCStatus.init(rawValue:)) }
        set { ucStatusRaw = newValue?.rawValue }
    }
}

@Model
final class AppSettings {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var ownerID: UUID
    var unitSystemRaw: String
    var appLockEnabled: Bool
    var lockDelaySeconds: Int
    var genericNotificationText: Bool
    var healthKitEnabled: Bool
    var cloudSyncEnabled: Bool
    var preferredSyncIntervalMinutes: Int
    var lastSuccessfulSyncAt: Date?
    var createdAt: Date
    var updatedAt: Date
    var serverRevision: Int64?
    var lastSyncedAt: Date?
    var syncStateRaw: String
    var deletedAt: Date?

    init(
        id: UUID = UUID(),
        ownerID: UUID,
        unitSystem: UnitSystem = .us,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.ownerID = ownerID
        unitSystemRaw = unitSystem.rawValue
        appLockEnabled = false
        lockDelaySeconds = 0
        genericNotificationText = true
        healthKitEnabled = false
        cloudSyncEnabled = false
        preferredSyncIntervalMinutes = 15
        self.createdAt = createdAt
        updatedAt = createdAt
        syncStateRaw = SyncState.localOnly.rawValue
    }
}

@Model
final class SyncOperation {
    @Attribute(.unique) var id: UUID
    var ownerID: UUID
    var entityTypeRaw: String
    var entityID: UUID
    var operationKindRaw: String
    var enqueuedAt: Date
    var notBefore: Date?
    var attemptCount: Int
    var lastAttemptAt: Date?
    var lastError: String?
    var completedAt: Date?

    init(
        id: UUID = UUID(),
        ownerID: UUID,
        entityType: SyncEntityType,
        entityID: UUID,
        operationKind: SyncOperationKind,
        enqueuedAt: Date = Date()
    ) {
        self.id = id
        self.ownerID = ownerID
        entityTypeRaw = entityType.rawValue
        self.entityID = entityID
        operationKindRaw = operationKind.rawValue
        self.enqueuedAt = enqueuedAt
        attemptCount = 0
    }

    var idempotencyKey: String {
        id.uuidString.lowercased()
    }
}
