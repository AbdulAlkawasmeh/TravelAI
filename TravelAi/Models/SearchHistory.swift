import Foundation

struct SearchHistory: Identifiable, Codable {
    let id: UUID
    let query: String
    let timestamp: Date
    
    init(id: UUID = UUID(), query: String, timestamp: Date = Date()) {
        self.id = id
        self.query = query
        self.timestamp = timestamp
    }
} 