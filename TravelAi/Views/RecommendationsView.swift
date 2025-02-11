import SwiftUI
import CoreLocation

struct RecommendationsView: View {
    let location: Location
    @StateObject private var viewModel = RecommendationsViewModel()
    @State private var selectedCategory: Recommendation.Category?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Location Header
                LocationHeaderView(location: location)
                
                // Categories
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Recommendation.Category.allCases, id: \.self) { category in
                            CategoryButton(
                                category: category,
                                isSelected: selectedCategory == category,
                                action: {
                                    withAnimation {
                                        selectedCategory = selectedCategory == category ? nil : category
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Recommendations List
                LazyVStack(spacing: 16) {
                    ForEach(filteredRecommendations) { recommendation in
                        RecommendationCard(recommendation: recommendation)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Recommendations")
        .onAppear {
            viewModel.loadRecommendations(for: location)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: MapView(location: location, recommendations: viewModel.recommendations)) {
                    Image(systemName: "map")
                }
            }
        }
    }
    
    private var filteredRecommendations: [Recommendation] {
        guard let category = selectedCategory else {
            return viewModel.recommendations
        }
        return viewModel.recommendations.filter { $0.category == category }
    }
}

struct LocationHeaderView: View {
    let location: Location
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(location.flag)
                    .font(.system(size: 60))
                VStack(alignment: .leading) {
                    Text(location.city)
                        .font(.title)
                        .bold()
                    Text(location.country)
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }
            Text(location.description)
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.top, 4)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
    }
}

struct CategoryButton: View {
    let category: Recommendation.Category
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: category.icon)
                Text(category.rawValue)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.accentColor : Color(.systemGray6))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }
}

struct RecommendationCard: View {
    let recommendation: Recommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: recommendation.imageSystemName)
                    .font(.title)
                    .frame(width: 60, height: 60)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                VStack(alignment: .leading) {
                    Text(recommendation.title)
                        .font(.headline)
                    
                    HStack {
                        Label(String(format: "%.1f", recommendation.rating), systemImage: "star.fill")
                            .foregroundColor(.yellow)
                        Text("•")
                        Text(recommendation.category.rawValue)
                        Text("•")
                        Text(recommendation.priceLevel.rawValue)
                            .foregroundColor(.green)
                    }
                    .font(.caption)
                }
            }
            
            Text(recommendation.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button(action: {}) {
                Text("Learn More")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    RecommendationsView(
        location: Location(
            city: "New York",
            country: "United States",
            countryCode: "US",
            description: "The Big Apple - a global center of culture, arts, and commerce",
            activities: ["Times Square", "Central Park", "Broadway Shows"],
            coordinate: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
        )
    )
} 