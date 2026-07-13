import SwiftData
import SwiftUI

@main
struct LeanMachine90App: App {
    private let modelContainer: ModelContainer
    @State private var environment: AppEnvironment

    init() {
        do {
            modelContainer = try PersistenceController.makeContainer()
        } catch {
            fatalError("Unable to create the local data store: \(error.localizedDescription)")
        }

        _environment = State(initialValue: AppEnvironment.live)
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(environment)
        }
        .modelContainer(modelContainer)
    }
}
