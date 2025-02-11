import Foundation
import Combine

@MainActor
class TravelSearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var suggestions: [Location] = []
    @Published var searchHistory: [SearchHistory] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let locationService = LocationService()
    private let historyManager = SearchHistoryManager()
    
    init() {
        searchHistory = historyManager.getSearchHistory()
        
        // Set up search with debounce
        $searchText
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.updateSuggestions(for: query)
            }
            .store(in: &cancellables)
    }
    
    private func updateSuggestions(for query: String) {
        isLoading = true
        error = nil
        
        do {
            suggestions = locationService.getSuggestions(for: query)
            isLoading = false
        } catch {
            self.error = "Failed to get suggestions: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func selectLocation(_ location: Location) {
        searchText = location.fullName
        historyManager.saveSearch(location.fullName)
        searchHistory = historyManager.getSearchHistory()
        suggestions = []
    }
    
    func clearHistory() {
        historyManager.clearHistory()
        searchHistory = []
    }
} 