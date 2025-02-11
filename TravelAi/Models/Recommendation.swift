import Foundation
import CoreLocation

struct Recommendation: Identifiable {
    let id: UUID
    let title: String
    let category: Category
    let description: String
    let rating: Double
    let priceLevel: PriceLevel
    let imageSystemName: String // In a real app, this would be an actual image URL
    let coordinate: CLLocationCoordinate2D
    
    enum Category: String, CaseIterable {
        case attraction = "Attractions"
        case restaurant = "Restaurants"
        case activity = "Activities"
        case hotel = "Hotels"
        case shopping = "Shopping"
        
        var icon: String {
            switch self {
            case .attraction: return "star.fill"
            case .restaurant: return "fork.knife"
            case .activity: return "figure.hiking"
            case .hotel: return "bed.double.fill"
            case .shopping: return "bag.fill"
            }
        }
    }
    
    enum PriceLevel: String, CaseIterable {
        case budget = "$"
        case moderate = "$$"
        case luxury = "$$$"
    }
    
    init(id: UUID = UUID(), title: String, category: Category, description: String, rating: Double, priceLevel: PriceLevel, imageSystemName: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.title = title
        self.category = category
        self.description = description
        self.rating = rating
        self.priceLevel = priceLevel
        self.imageSystemName = imageSystemName
        self.coordinate = coordinate
    }
} 