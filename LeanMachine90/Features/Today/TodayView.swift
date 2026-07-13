import SwiftUI

struct TodayView: View {
    @Environment(AppEnvironment.self) private var environment

    private var today: CalendarDay {
        environment.calendarDayService.day(
            for: environment.now(),
            in: .autoupdatingCurrent
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Your plan, one day at a time.")
                        .font(.largeTitle.bold())
                    Text(today.normalizedDate, format: .dateTime.weekday(.wide).month(.wide).day())
                        .foregroundStyle(.secondary)
                }

                FoundationStatusCard(
                    icon: "iphone",
                    title: "Local-first",
                    detail: "Your entries will save on this device before any future sync begins."
                )

                FoundationStatusCard(
                    icon: "icloud.slash",
                    title: "Cloud sync is off",
                    detail: "Sync will remain opt-in when the cloud service is introduced."
                )

                VStack(alignment: .leading, spacing: 10) {
                    Text("Next action")
                        .font(.headline)

                    Button("Set up your plan") {
                        // Onboarding is the next vertical slice.
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(true)

                    Text("Onboarding and the first saved morning check-in arrive in Milestone 2.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .navigationTitle("Today")
    }
}
