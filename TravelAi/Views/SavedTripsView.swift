import SwiftUI

struct SavedTripsView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<3) { _ in
                    SavedTripCard()
                }
            }
            .navigationTitle("Saved Trips")
        }
    }
}

struct SavedTripCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Trip Name")
                    .font(.headline)
                Spacer()
                Menu {
                    Button(action: {}) {
                        Label("Edit", systemImage: "pencil")
                    }
                    Button(action: {}) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    Button(role: .destructive, action: {}) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
            
            Text("Destination")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Planned Date: June 2024")
                .font(.caption)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    SavedTripsView()
} 