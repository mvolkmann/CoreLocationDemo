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

struct ContentView: View {
    private static let appleParkLatitude = 37.334_900
    private static let appleParkLongitude = -122.009_020
    private static let meters = 750.0

    @State private var initialCenter = CLLocationCoordinate2D(
        latitude: Self.appleParkLatitude,
        longitude: Self.appleParkLongitude
    )
    @State private var currentCenter = CLLocationCoordinate2D(
        latitude: Self.appleParkLatitude,
        longitude: Self.appleParkLongitude
    )

    @StateObject var locationManager = LocationManager()

    init() {
        // This has no effect.
        MKMapView.appearance().mapType = .hybrid
    }

    func panToCurrentLocation() {
        guard let location = locationManager.location else { return }
        Task { @MainActor in
            initialCenter = location
            currentCenter = location
        }
    }

    var body: some View {
        VStack {
            HStack {
                LocationButton {
                    locationManager.requestLocation()
                }
                .foregroundColor(.white) // defaults to black
                Spacer()
                if locationManager.location != nil {
                    Button("Return") {
                        panToCurrentLocation()
                    }
                    .buttonStyle(.bordered)
                }
            }

            // Display the current location.
            // This updates if the user pans the map.
            let lat = currentCenter.latitude
            let lng = currentCenter.longitude
            Text("Lat: \(lat), Lng: \(lng)")

            // A binding must be passed for currentCenter so it
            // can be modified if the user pans or zooms the map.
            MapView(initialCenter: initialCenter, currentCenter: $currentCenter)

            Spacer()
        }
        .padding()
        .onChange(of: locationManager.location) { _ in
            panToCurrentLocation()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
