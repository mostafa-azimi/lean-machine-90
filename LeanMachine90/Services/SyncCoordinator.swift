import Foundation

enum SyncTrigger: String, Codable, Sendable {
    case localChange
    case appForeground
    case manual
    case backgroundOpportunity
}

protocol SyncCoordinating: Sendable {
    func requestSync(trigger: SyncTrigger) async
}

struct DisabledSyncCoordinator: SyncCoordinating {
    func requestSync(trigger: SyncTrigger) async {
        // Cloud synchronization is intentionally disabled until the user opts in.
    }
}
