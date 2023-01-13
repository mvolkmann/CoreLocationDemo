import CoreLocation
import CoreLocationUI
import MapKit
import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager.shared

    var body: some View {
        VStack {
            if locationManager.userLocation == nil {
                // Tap this to get the device location and pan the map to it.
                LocationButton {
                    locationManager.requestLocation()
                }
                .foregroundColor(.white) // defaults to black
            } else {
                // Tap this to reset the map to the device location.
                Button("Reset") {
                    locationManager.panToDeviceLocation()
                }
                .buttonStyle(.bordered)
            }

            // This updates if the user drags the map.
            if let c = locationManager.mapCenter {
                Text("Lat: \(c.latitude), Lng: \(c.longitude)")
            }

            MapView(initialCenter: locationManager.initialCenter)

            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
