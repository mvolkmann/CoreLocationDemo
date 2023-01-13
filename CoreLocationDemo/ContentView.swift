import CoreLocation
import CoreLocationUI
import MapKit
import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager.shared

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
                        locationManager.reset()
                    }
                    .buttonStyle(.bordered)
                }
            }

            // This updates if the user pans the map.
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
