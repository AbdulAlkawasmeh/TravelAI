import Foundation
import CoreLocation

class LocationService {
    // This is a sample of the full dataset. In a real app, this would come from a database or API
    private let locations = [
        // North America
        Location(
            city: "New York City",
            country: "United States",
            countryCode: "US",
            description: "The Big Apple - a global center of culture, arts, and commerce",
            activities: ["Times Square", "Central Park", "Broadway Shows"],
            coordinate: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
        ),
        Location(
            city: "Toronto",
            country: "Canada",
            countryCode: "CA",
            description: "Canada's largest city and cultural hub",
            activities: ["CN Tower", "Royal Ontario Museum", "Shopping"],
            coordinate: CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832)
        ),
        
        // Europe
        Location(
            city: "Paris",
            country: "France",
            countryCode: "FR",
            description: "The City of Light - world capital of art and culture",
            activities: ["Eiffel Tower", "Louvre Museum", "Seine River Cruise"],
            coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)
        ),
        Location(
            city: "London",
            country: "United Kingdom",
            countryCode: "GB",
            description: "Historic capital blending tradition with modern culture",
            activities: ["Big Ben", "Tower Bridge", "British Museum"],
            coordinate: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278)
        ),
        
        // Asia
        Location(
            city: "Tokyo",
            country: "Japan",
            countryCode: "JP",
            description: "Ultra-modern city with traditional charm",
            activities: ["Shibuya Crossing", "Mount Fuji", "Imperial Palace"],
            coordinate: CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503)
        ),
        Location(
            city: "Singapore",
            country: "Singapore",
            countryCode: "SG",
            description: "Modern city-state known for cleanliness and innovation",
            activities: ["Gardens by the Bay", "Marina Bay Sands", "Sentosa Island"],
            coordinate: CLLocationCoordinate2D(latitude: 1.3521, longitude: 103.8198)
        ),
        
        // Australia/Oceania
        Location(
            city: "Sydney",
            country: "Australia",
            countryCode: "AU",
            description: "Stunning harbor city with iconic architecture",
            activities: ["Opera House", "Bondi Beach", "Harbour Bridge"],
            coordinate: CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093)
        ),
        
        // Africa
        Location(
            city: "Cape Town",
            country: "South Africa",
            countryCode: "ZA",
            description: "Coastal city with dramatic mountain backdrop",
            activities: ["Table Mountain", "Robben Island", "Wine Tours"],
            coordinate: CLLocationCoordinate2D(latitude: -33.9249, longitude: 18.4241)
        ),
        
        // Add hundreds more cities here...
    ]
    
    private var citiesByCountry: [String: [Location]] {
        Dictionary(grouping: locations) { $0.country }
    }
    
    func getSuggestions(for query: String) -> [Location] {
        guard !query.isEmpty else { return [] }
        
        let lowercasedQuery = query.lowercased()
        return locations.filter {
            $0.city.lowercased().contains(lowercasedQuery) ||
            $0.country.lowercased().contains(lowercasedQuery)
        }
        .sorted { $0.city < $1.city }
    }
    
    func getCountries() -> [String] {
        Array(Set(locations.map { $0.country })).sorted()
    }
    
    func getCities(for country: String) -> [Location] {
        locations.filter { $0.country == country }
            .sorted { $0.city < $1.city }
    }
} 