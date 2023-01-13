import CoreLocation
import SwiftUI

private let appleParkLatitude = 37.334_900
private let appleParkLongitude = -122.009_020

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var error: Error?
    @Published var mapCenter: CLLocationCoordinate2D?
    @Published var initialCenter = CLLocationCoordinate2D(
        latitude: appleParkLatitude,
        longitude: appleParkLongitude
    )
    @Published var userLocation: CLLocationCoordinate2D?

    let manager = CLLocationManager()

    static var shared = LocationManager()

    override private init() {
        super.init()
        manager.delegate = self
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        userLocation = locations.first?.coordinate
        initialCenter = userLocation!
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        self.error = error
    }

    func requestLocation() {
        manager.requestLocation()
    }

    func reset() {
        if let userLocation {
            initialCenter = userLocation
        }
    }
}
