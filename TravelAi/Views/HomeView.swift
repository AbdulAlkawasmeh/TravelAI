import SwiftUI
import Combine

struct HomeView: View {
    @StateObject private var viewModel = TravelSearchViewModel()
    @State private var isSearching = false
    @FocusState private var isSearchFieldFocused: Bool
    @State private var showError = false
    @EnvironmentObject private var locationManager: LocationSelectionManager
    @State private var showRecommendations = false
    @GestureState private var isDetectingLongPress = false
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Search Bar with Suggestions
                    VStack(alignment: .leading) {
                        TextField("Where do you want to go?", text: $viewModel.searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .focused($isSearchFieldFocused)
                            .submitLabel(.search)
                            .onSubmit {
                                isSearchFieldFocused = false
                                if !viewModel.searchText.isEmpty {
                                    isSearching = true
                                }
                            }
                            .onChange(of: scenePhase) { newPhase in
                                if newPhase != .active {
                                    isSearchFieldFocused = false
                                }
                            }
                            .padding(.horizontal)
                        
                        if !viewModel.suggestions.isEmpty && !viewModel.searchText.isEmpty {
                            SuggestionsView(suggestions: viewModel.suggestions) { location in
                                isSearchFieldFocused = false
                                viewModel.selectLocation(location)
                            }
                            .frame(height: 200)
                        }
                        
                        if viewModel.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .padding()
                                Spacer()
                            }
                        }
                    }
                    
                    // Get Recommendations Button
                    NavigationLink(isActive: $showRecommendations) {
                        if let location = locationManager.selectedLocation {
                            RecommendationsView(location: location)
                        }
                    } label: {
                        Button(action: {
                            withAnimation {
                                isSearchFieldFocused = false
                                if locationManager.selectedLocation != nil {
                                    showRecommendations = true
                                }
                            }
                        }) {
                            Text("Get Recommendations")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(locationManager.selectedLocation != nil ? Color.accentColor : Color.gray)
                                .cornerRadius(10)
                                .scaleEffect(isDetectingLongPress ? 0.95 : 1.0)
                        }
                    }
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 0.1)
                            .updating($isDetectingLongPress) { currentState, gestureState, _ in
                                gestureState = currentState
                            }
                    )
                    .padding(.horizontal)
                    .disabled(locationManager.selectedLocation == nil)
                    
                    // Recent Searches
                    if viewModel.suggestions.isEmpty && !viewModel.isLoading {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Recent Searches")
                                    .font(.headline)
                                Spacer()
                                if !viewModel.searchHistory.isEmpty {
                                    Button("Clear All") {
                                        viewModel.clearHistory()
                                    }
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                }
                            }
                            .padding(.horizontal)
                            
                            ForEach(viewModel.searchHistory) { history in
                                SearchHistoryRow(history: history) {
                                    isSearchFieldFocused = false
                                    viewModel.searchText = history.query
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical)
            }
            .scrollDismissesKeyboard(.immediately)
            .navigationTitle("TravelAI")
            .alert("Error", isPresented: $showError) {
                Button("OK") {
                    viewModel.error = nil
                }
            } message: {
                Text(viewModel.error ?? "An unknown error occurred")
            }
            .onChange(of: viewModel.error) { error in
                showError = error != nil
            }
            .toolbar {
                if isSearchFieldFocused {
                    Button("Cancel") {
                        isSearchFieldFocused = false
                        viewModel.searchText = ""
                    }
                }
            }
        }
    }
}

struct SearchHistoryRow: View {
    let history: SearchHistory
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: "clock")
                    .foregroundColor(.secondary)
                    .frame(width: 20)
                
                Text(history.query)
                    .lineLimit(1)
                
                Spacer(minLength: 8)
                
                Text(history.timestamp.formatted(.relative(presentation: .named)))
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color(.systemBackground))
    }
}

#Preview {
    HomeView()
        .environmentObject(LocationSelectionManager())
} 