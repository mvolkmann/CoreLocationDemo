import CoreLocation
import SwiftUI

private let appleParkLatitude = 37.334_900
private let appleParkLongitude = -122.009_020

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var error: Error?

    // This is the requested map center.
    @Published var initialCenter = CLLocationCoordinate2D(
        latitude: appleParkLatitude,
        longitude: appleParkLongitude
    )

    // This is the current map center which differs
    // from initialCenter if the user drags the map.
    @Published var mapCenter: CLLocationCoordinate2D?

    // This is the device location.
    // It is not updated if the device moves.
    @Published var userLocation: CLLocationCoordinate2D?

    let manager = CLLocationManager()

    static var shared = LocationManager()

    override private init() {
        super.init()
        manager.delegate = self
    }

    // This is called when the device location is determined.
    // An attempt to determine the location is triggered by
    // the `requestLocation` method below.
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        userLocation = locations.first?.coordinate
        initialCenter = userLocation!
    }

    // This is called if there is an error determining the device location.
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("LocationManager error:")
        self.error = error
    }

    // This sets the map center to the device location.
    func panToDeviceLocation() {
        guard let userLocation else { return }

        // Hack alert!
        // If the initial map center is already at the user location ...
        if initialCenter == userLocation {
            // Change it slightly to try `MapView` to re-render.
            initialCenter.longitude += 0.0000001
        } else {
            // Go to the user location.
            initialCenter = userLocation
        }
    }

    // This is called by `ContentView`.
    func requestLocation() {
        manager.requestLocation()
    }
}
