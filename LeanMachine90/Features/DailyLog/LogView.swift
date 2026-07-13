import SwiftUI

struct LogView: View {
    var body: some View {
        FeatureEmptyState(
            icon: "square.and.pencil",
            title: "Nothing logged yet",
            message: "Morning, nutrition, training, recovery, and evening entries will live here."
        )
        .navigationTitle("Log")
    }
}
