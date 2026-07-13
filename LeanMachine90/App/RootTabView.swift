import SwiftUI

struct RootTabView: View {
    @State private var settingsPresented = false

    var body: some View {
        TabView {
            NavigationStack {
                TodayView()
                    .toolbar { settingsToolbar }
            }
            .tabItem {
                Label("Today", systemImage: "sun.max")
            }

            NavigationStack {
                PlanView()
                    .toolbar { settingsToolbar }
            }
            .tabItem {
                Label("Plan", systemImage: "calendar")
            }

            NavigationStack {
                LogView()
                    .toolbar { settingsToolbar }
            }
            .tabItem {
                Label("Log", systemImage: "square.and.pencil")
            }

            NavigationStack {
                PhotosView()
                    .toolbar { settingsToolbar }
            }
            .tabItem {
                Label("Photos", systemImage: "photo.on.rectangle")
            }

            NavigationStack {
                ProgressDashboardView()
                    .toolbar { settingsToolbar }
            }
            .tabItem {
                Label("Progress", systemImage: "chart.xyaxis.line")
            }
        }
        .sheet(isPresented: $settingsPresented) {
            NavigationStack {
                SettingsView()
            }
        }
    }

    @ToolbarContentBuilder
    private var settingsToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                settingsPresented = true
            } label: {
                Label("Settings", systemImage: "gearshape")
            }
        }
    }
}

#if DEBUG
#Preview {
    RootTabView()
        .environment(AppEnvironment.preview)
        .modelContainer(PreviewData.container)
}
#endif
