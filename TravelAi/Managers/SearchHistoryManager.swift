import Foundation

class SearchHistoryManager {
    private let userDefaults = UserDefaults.standard
    private let historyKey = "searchHistory"
    private let maxHistoryItems = 10
    
    func saveSearch(_ query: String) {
        var history = getSearchHistory()
        let newSearch = SearchHistory(query: query)
        
        // Remove duplicate if exists
        history.removeAll { $0.query == query }
        
        // Add new search at the beginning
        history.insert(newSearch, at: 0)
        
        // Keep only the most recent searches
        if history.count > maxHistoryItems {
            history = Array(history.prefix(maxHistoryItems))
        }
        
        if let encoded = try? JSONEncoder().encode(history) {
            userDefaults.set(encoded, forKey: historyKey)
        }
    }
    
    func getSearchHistory() -> [SearchHistory] {
        guard let data = userDefaults.data(forKey: historyKey),
              let history = try? JSONDecoder().decode([SearchHistory].self, from: data) else {
            return []
        }
        return history
    }
    
    func clearHistory() {
        userDefaults.removeObject(forKey: historyKey)
    }
} 