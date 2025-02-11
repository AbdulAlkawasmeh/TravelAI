import Foundation

class OpenAIService {
    private let apiKey: String
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    init(apiKey: String = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? "") {
        self.apiKey = apiKey
    }
    
    func generateTravelSuggestions(for query: String) async throws -> [TravelSuggestion] {
        let prompt = """
        Generate travel suggestions for: \(query)
        Provide 3 destinations with the following information for each:
        - Destination name
        - Brief description
        - Estimated cost
        - List of activities
        Format the response as a JSON array with the following structure:
        [
          {
            "destination": "string",
            "description": "string",
            "estimatedCost": "string",
            "activities": ["string"]
          }
        ]
        """
        
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = [
            "model": "gpt-4",
            "messages": [
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7
        ] as [String: Any]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        struct OpenAIResponse: Codable {
            let choices: [Choice]
            
            struct Choice: Codable {
                let message: Message
                
                struct Message: Codable {
                    let content: String
                }
            }
        }
        
        let openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        guard let jsonString = openAIResponse.choices.first?.message.content else {
            throw URLError(.cannotParseResponse)
        }
        
        // Convert the JSON string to Data
        guard let jsonData = jsonString.data(using: .utf8) else {
            throw URLError(.cannotParseResponse)
        }
        
        // Parse the suggestions
        return try JSONDecoder().decode([TravelSuggestion].self, from: jsonData)
    }
} 