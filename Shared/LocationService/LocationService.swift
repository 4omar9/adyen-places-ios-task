//
//  LocationService.swift
//  PlacesSwiftUI
//

import Foundation
import CoreLocation

final class LocationService: NSObject, CLLocationManagerDelegate {
    var coordinates: ((CLLocationCoordinate2D) -> Void)?

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() -> Bool {
        locationManager.startUpdatingLocation()
        return CLLocationManager.locationServicesEnabled()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.last {
            coordinates?(location.coordinate)
        }
    }
}
