import Foundation
import CoreLocation

@MainActor
class RecommendationsViewModel: ObservableObject {
    @Published var recommendations: [Recommendation] = []
    
    func loadRecommendations(for location: Location) {
        // In a real app, this would fetch from an API
        recommendations = generateSampleRecommendations(for: location)
    }
    
    private func generateSampleRecommendations(for location: Location) -> [Recommendation] {
        var recommendations: [Recommendation] = []
        
        // Add attractions
        location.activities.forEach { activity in
            recommendations.append(
                Recommendation(
                    title: activity,
                    category: .attraction,
                    description: "Popular attraction in \(location.city). A must-visit destination for tourists.",
                    rating: Double.random(in: 4.0...5.0),
                    priceLevel: .moderate,
                    imageSystemName: "photo.fill",
                    coordinate: CLLocationCoordinate2D(
                        latitude: location.coordinate.latitude + Double.random(in: -0.02...0.02),
                        longitude: location.coordinate.longitude + Double.random(in: -0.02...0.02)
                    )
                )
            )
        }
        
        // Add some restaurants
        recommendations.append(contentsOf: [
            Recommendation(
                title: "Local Cuisine Restaurant",
                category: .restaurant,
                description: "Experience authentic local cuisine in a charming setting",
                rating: 4.8,
                priceLevel: .moderate,
                imageSystemName: "fork.knife",
                coordinate: CLLocationCoordinate2D(
                    latitude: location.coordinate.latitude + Double.random(in: -0.02...0.02),
                    longitude: location.coordinate.longitude + Double.random(in: -0.02...0.02)
                )
            ),
            Recommendation(
                title: "Fine Dining Experience",
                category: .restaurant,
                description: "Upscale dining with spectacular city views",
                rating: 4.9,
                priceLevel: .luxury,
                imageSystemName: "fork.knife",
                coordinate: CLLocationCoordinate2D(
                    latitude: location.coordinate.latitude + Double.random(in: -0.02...0.02),
                    longitude: location.coordinate.longitude + Double.random(in: -0.02...0.02)
                )
            )
        ])
        
        // Add hotels
        recommendations.append(contentsOf: [
            Recommendation(
                title: "City Center Hotel",
                category: .hotel,
                description: "Luxurious accommodation in the heart of the city",
                rating: 4.7,
                priceLevel: .luxury,
                imageSystemName: "bed.double.fill",
                coordinate: CLLocationCoordinate2D(
                    latitude: location.coordinate.latitude + Double.random(in: -0.02...0.02),
                    longitude: location.coordinate.longitude + Double.random(in: -0.02...0.02)
                )
            ),
            Recommendation(
                title: "Boutique Hotel",
                category: .hotel,
                description: "Charming boutique hotel with unique character",
                rating: 4.5,
                priceLevel: .moderate,
                imageSystemName: "bed.double.fill",
                coordinate: CLLocationCoordinate2D(
                    latitude: location.coordinate.latitude + Double.random(in: -0.02...0.02),
                    longitude: location.coordinate.longitude + Double.random(in: -0.02...0.02)
                )
            )
        ])
        
        return recommendations
    }
} 