import SwiftUI
import CoreLocation

struct SuggestionsView: View {
    let suggestions: [Location]
    let onSelect: (Location) -> Void
    @EnvironmentObject private var locationManager: LocationSelectionManager
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(suggestions) { location in
                    SuggestionRow(location: location) {
                        onSelect(location)
                        locationManager.selectedLocation = location
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
        .background(Color(.systemGray6))
    }
}

struct SuggestionRow: View {
    let location: Location
    let onTap: () -> Void
    @GestureState private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(location.flag)
                        .font(.title2)
                        .frame(minWidth: 40)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(location.city)
                            .font(.headline)
                            .lineLimit(1)
                        Text(location.country)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                
                Text(location.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(location.activities.prefix(2), id: \.self) { activity in
                            Text(activity)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.accentColor.opacity(0.1))
                                .cornerRadius(4)
                        }
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 2)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isPressed)
        .gesture(
            DragGesture(minimumDistance: 0)
                .updating($isPressed) { _, state, _ in
                    state = true
                }
        )
    }
}

#Preview {
    SuggestionsView(
        suggestions: [
            Location(
                city: "New York",
                country: "United States",
                countryCode: "US",
                description: "The Big Apple - a global center of culture, arts, and commerce",
                activities: ["Times Square", "Central Park", "Broadway Shows"],
                coordinate: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
            )
        ],
        onSelect: { _ in }
    )
    .environmentObject(LocationSelectionManager())
} 