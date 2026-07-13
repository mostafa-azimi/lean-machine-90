import SwiftData

enum LeanMachineSchemaV1: VersionedSchema {
    static let versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] {
        [
            UserProfile.self,
            GoalPlan.self,
            TargetRevision.self,
            DayPlan.self,
            DailyLog.self,
            AppSettings.self,
            SyncOperation.self
        ]
    }
}

enum LeanMachineMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [LeanMachineSchemaV1.self]
    }

    static var stages: [MigrationStage] {
        []
    }
}
