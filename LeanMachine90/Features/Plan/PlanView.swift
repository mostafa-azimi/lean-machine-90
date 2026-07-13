import SwiftUI

struct PlanView: View {
    var body: some View {
        FeatureEmptyState(
            icon: "calendar.badge.plus",
            title: "No active plan",
            message: "Your targets, schedule, and plan phases will appear here after onboarding."
        )
        .navigationTitle("Plan")
    }
}
