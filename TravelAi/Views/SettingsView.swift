import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showLocationSettings = false
    
    var body: some View {
        NavigationView {
            List {
                Section("Appearance") {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
                
                Section("Location") {
                    Button("Location Settings") {
                        showLocationSettings = true
                    }
                }
                
                Section("Data") {
                    Button("Clear Search History") {
                        // Add clear history functionality
                    }
                }
                
                Section("Support") {
                    Button("Provide Feedback") {
                        // Add feedback functionality
                    }
                    
                    Button("Report an Issue") {
                        // Add report issue functionality
                    }
                }
                
                Section("About") {
                    Text("Version 1.0.0")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
} 