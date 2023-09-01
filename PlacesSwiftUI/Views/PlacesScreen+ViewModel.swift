//
//  PlacesScreen+ViewModel.swift
//  Places
//
//

import Foundation
import AdyenNetworking

extension PlacesScreen {

    final class ViewModel: ObservableObject {

        @Published var state: State = .loading
        @Published var preciseLocationEnabled: Bool = false
        @Published var radiusOfInterest: Double = 1000.0

        private let apiClient: APIClientProtocol
        private let locationService: LocationService
        private var coordinates: String? = nil

        enum State {
            case loading
            case loaded([Place])
            case error(String)
        }

        init(
            apiContext: AnyAPIContext = PlacesAPIContext(),
            locationService: LocationService = .init()
        ) {
            self.apiClient = APIClient(apiContext: apiContext)
            self.locationService = locationService
            locationService.requestLocationAuthorization()
        }

        func enableUpdatingLocation() {
            Task {
                if await locationService.startUpdatingLocation() {
                    print("Location Authorized")
                } else {
                    print("Location Not Authorized")
                    // Location not authorized user needs to enable it from the settings
                }
                await loadData()
            }
            locationService.coordinates = { coordinate in
                self.coordinates = "\(coordinate.latitude),\(coordinate.longitude)"
            }
        }

        func disableUpdatingLocation() {
            locationService.stopUpdatingLocation()
            Task {
                await loadData()
            }
        }
        
        @MainActor
        func loadData() {
            Task {
                do {
                    let places = try await fetchPlaces(
                        coordinate: preciseLocationEnabled ? coordinates: nil,
                        radius: preciseLocationEnabled ? "\(Int(radiusOfInterest))": nil
                    )
                    state = .loaded(places)
                } catch {
                    state = .error("Data not loaded with error \(error)")
                }
            }
        }

        private func fetchPlaces(coordinate: String? = nil, radius: String? = nil) async throws -> [Place] {
            try await withCheckedThrowingContinuation { continuation in
                let queryItems = [
                    URLQueryItem(name: "ll", value: coordinate),
                    URLQueryItem(name: "radius", value: radius)
                ]
                let request = SearchPlacesRequest(queryParameters: queryItems)
                apiClient.perform(request) { result in
                    continuation.resume(with: result.map { $0.results })
                }
            }
        }
    }
}
