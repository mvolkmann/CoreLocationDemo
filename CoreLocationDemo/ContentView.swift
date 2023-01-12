import CoreLocation
import CoreLocationUI
import MapKit
import SwiftUI

extension CLLocationCoordinate2D: Equatable {
    public static func == (
        lhs: CLLocationCoordinate2D,
        rhs: CLLocationCoordinate2D
    ) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

private let appleParkLatitude = 37.334_900
private let appleParkLongitude = -122.009_020

struct ContentView: View {
    @StateObject private var locationManager = LocationManager.shared

    @State var initialCenter = CLLocationCoordinate2D(
        latitude: appleParkLatitude,
        longitude: appleParkLongitude
    )
    @State var currentCenter: CLLocationCoordinate2D?

    init() {
        // Other options are .standard and .satellite.
        MKMapView.appearance().mapType = .hybrid
    }

    func panToCurrentLocation() {
        guard let location = locationManager.userLocation else { return }
        print("panToCurrentLocation: location =", location)
        initialCenter = location
    }

    var body: some View {
        VStack {
            HStack {
                LocationButton {
                    locationManager.requestLocation()
                }
                .foregroundColor(.white) // defaults to black
                Spacer()
                if locationManager.userLocation != nil {
                    Button("Return") {
                        panToCurrentLocation()
                    }
                    .buttonStyle(.bordered)
                }
            }

            // Display the current location.
            // This updates if the user pans the map.
            if let c = currentCenter {
                Text("Lat: \(c.latitude), Lng: \(c.longitude)")
            }

            // MapView does not change the value of `initialCenter`,
            // so we do not pass a Binding.
            // MapView does change the value of `currentCenter`,
            // so we pass a Binding.
            MapView(
                initialCenter: initialCenter,
                currentCenter: $currentCenter
            )

            Spacer()
        }
        .padding()
        .onChange(of: locationManager.userLocation) { _ in
            panToCurrentLocation()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
