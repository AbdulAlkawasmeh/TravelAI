import Foundation

struct TravelSuggestion: Identifiable, Codable {
    let id: UUID
    let destination: String
    let description: String
    let estimatedCost: String
    let activities: [String]
    
    init(id: UUID = UUID(), destination: String, description: String, estimatedCost: String, activities: [String]) {
        self.id = id
        self.destination = destination
        self.description = description
        self.estimatedCost = estimatedCost
        self.activities = activities
    }
} 