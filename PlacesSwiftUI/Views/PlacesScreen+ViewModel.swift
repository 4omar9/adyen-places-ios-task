//
//  PlacesScreen+ViewModel.swift
//  Places
//
//

import Foundation
import AdyenNetworking

extension PlacesScreen {

    final class ViewModel: ObservableObject {
        enum State {
            case loading
            case loaded([Place])
            case error(String)
        }
        @Published var state: State = .loading
        let apiClient: APIClientProtocol

        init(apiContext: AnyAPIContext = PlacesAPIContext()) {
            self.apiClient = APIClient(apiContext: apiContext)
        }
        @MainActor
        func loadData() {
            Task {
                do {
                    let places = try await fetchPlaces()
                    state = .loaded(places)
                } catch {
                    state = .error("Data not loaded with error \(error)")
                }
            }
        }
        private func fetchPlaces() async throws -> [Place] {
            try await withCheckedThrowingContinuation { continuation in
                apiClient.perform(SearchPlacesRequest()) { result in
                    continuation.resume(with: result.map { $0.results })
                }
            }
        }
    }
}
