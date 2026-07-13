#if DEBUG
import SwiftData

enum PreviewData {
    static let container: ModelContainer = {
        do {
            return try PersistenceController.makeContainer(inMemory: true)
        } catch {
            fatalError("Unable to create preview data: \(error.localizedDescription)")
        }
    }()
}
#endif
