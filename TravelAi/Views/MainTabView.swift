import SwiftUI

struct MainTabView: View {
    @State private var selectedLocation: Location?
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            if let location = selectedLocation {
                RecommendationsView(location: location)
                    .tabItem {
                        Label("Explore", systemImage: "map.fill")
                    }
            } else {
                Text("Select a location to see recommendations")
                    .tabItem {
                        Label("Explore", systemImage: "map.fill")
                    }
            }
            
            SavedTripsView()
                .tabItem {
                    Label("Saved", systemImage: "heart.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .environmentObject(LocationSelectionManager())
    }
}

// Add this class to manage location selection across views
class LocationSelectionManager: ObservableObject {
    @Published var selectedLocation: Location?
}

#Preview {
    MainTabView()
} 