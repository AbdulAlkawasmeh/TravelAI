import SwiftUI
import MapKit

struct MapView: View {
    let location: Location
    let recommendations: [Recommendation]
    @State private var region: MKCoordinateRegion
    @State private var selectedRecommendation: Recommendation?
    @State private var showingDetail = false
    
    init(location: Location, recommendations: [Recommendation]) {
        self.location = location
        self.recommendations = recommendations
        
        // Set initial region to the first recommendation or city center
        let initialCoordinate = recommendations.first?.coordinate ?? 
            CLLocationCoordinate2D(latitude: location.coordinate.latitude, 
                                 longitude: location.coordinate.longitude)
        
        _region = State(initialValue: MKCoordinateRegion(
            center: initialCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region,
                annotationItems: recommendations) { recommendation in
                MapAnnotation(coordinate: recommendation.coordinate) {
                    Button {
                        selectedRecommendation = recommendation
                        showingDetail = true
                    } label: {
                        VStack {
                            Image(systemName: recommendation.category.icon)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 32, height: 32)
                                .background(Color.accentColor)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                            
                            if selectedRecommendation?.id == recommendation.id {
                                Text(recommendation.title)
                                    .font(.caption)
                                    .padding(4)
                                    .background(Color.white)
                                    .cornerRadius(4)
                                    .shadow(radius: 1)
                            }
                        }
                    }
                }
            }
            
            VStack {
                Spacer()
                
                // Category Filter Buttons
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(Recommendation.Category.allCases, id: \.self) { category in
                            Button {
                                filterMap(by: category)
                            } label: {
                                HStack {
                                    Image(systemName: category.icon)
                                    Text(category.rawValue)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(.systemBackground))
                                .cornerRadius(20)
                                .shadow(radius: 2)
                            }
                        }
                    }
                    .padding()
                }
                .background(Color.black.opacity(0.1))
            }
        }
        .sheet(isPresented: $showingDetail) {
            if let recommendation = selectedRecommendation {
                RecommendationDetailView(recommendation: recommendation)
            }
        }
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func filterMap(by category: Recommendation.Category) {
        let filteredLocations = recommendations.filter { $0.category == category }
        if let first = filteredLocations.first {
            withAnimation {
                region.center = first.coordinate
            }
        }
    }
}

struct RecommendationDetailView: View {
    let recommendation: Recommendation
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Image(systemName: recommendation.imageSystemName)
                        .font(.system(size: 40))
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .background(Color(.systemGray6))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(recommendation.title)
                            .font(.title2)
                            .bold()
                        
                        HStack {
                            Label(String(format: "%.1f", recommendation.rating), 
                                  systemImage: "star.fill")
                                .foregroundColor(.yellow)
                            Text("•")
                            Text(recommendation.category.rawValue)
                            Text("•")
                            Text(recommendation.priceLevel.rawValue)
                                .foregroundColor(.green)
                        }
                        
                        Text(recommendation.description)
                            .foregroundColor(.secondary)
                        
                        Button(action: {}) {
                            Text("Book Now")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top)
                    }
                    .padding()
                }
            }
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
} 