import SwiftData

enum PersistenceController {
    static func makeContainer(inMemory: Bool = false) throws -> ModelContainer {
        let schema = Schema(LeanMachineSchemaV1.models)
        let configuration = ModelConfiguration(
            "LeanMachine90",
            schema: schema,
            isStoredInMemoryOnly: inMemory
        )

        return try ModelContainer(
            for: schema,
            migrationPlan: LeanMachineMigrationPlan.self,
            configurations: [configuration]
        )
    }
}
