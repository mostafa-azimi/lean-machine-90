import SwiftUI

struct ProgressDashboardView: View {
    var body: some View {
        FeatureEmptyState(
            icon: "chart.xyaxis.line",
            title: "No trend data",
            message: "Weight, measurements, adherence, recovery, and workout trends will appear as you log."
        )
        .navigationTitle("Progress")
    }
}
