import Foundation
import CoreLocation

struct Location: Identifiable, Codable {
    let id: UUID
    let city: String
    let country: String
    let countryCode: String // ISO 3166-1 alpha-2 code
    let description: String
    let activities: [String]
    let coordinate: CLLocationCoordinate2D
    
    enum CodingKeys: String, CodingKey {
        case id, city, country, countryCode, description, activities
        case latitude, longitude
    }
    
    init(id: UUID = UUID(), city: String, country: String, countryCode: String, 
         description: String, activities: [String], coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.city = city
        self.country = country
        self.countryCode = countryCode
        self.description = description
        self.activities = activities
        self.coordinate = coordinate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        city = try container.decode(String.self, forKey: .city)
        country = try container.decode(String.self, forKey: .country)
        countryCode = try container.decode(String.self, forKey: .countryCode)
        description = try container.decode(String.self, forKey: .description)
        activities = try container.decode([String].self, forKey: .activities)
        
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(city, forKey: .city)
        try container.encode(country, forKey: .country)
        try container.encode(countryCode, forKey: .countryCode)
        try container.encode(description, forKey: .description)
        try container.encode(activities, forKey: .activities)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
    
    var fullName: String {
        "\(city), \(country) \(flag)"
    }
    
    var flag: String {
        countryCode
            .unicodeScalars
            .map { String(UnicodeScalar(127397 + $0.value)!) }
            .joined()
    }
} 