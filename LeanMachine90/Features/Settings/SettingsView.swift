import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section("Privacy") {
                Label("Local storage active", systemImage: "iphone")
                Label("Cloud sync off", systemImage: "icloud.slash")
                Label("No analytics or tracking", systemImage: "hand.raised")
            }

            Section("Foundation") {
                LabeledContent("App version", value: "0.1.0")
                LabeledContent("Data schema", value: "1.0.0")
                LabeledContent("Minimum iOS", value: "17")
            }

            Section {
                Text("Lean Machine 90 supports personal tracking and habit planning. It does not diagnose or treat medical conditions and does not replace medical care.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Settings")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}
