import MapKit
import SwiftUI

/**
 For now we have to wrap an MKMapView in a UIViewRepresentable
 in order to use some MapKit features in SwiftUI.

 I was getting the error "The following Metal object is being
 destroyed while still required to be alive by the command buffer".
 This thread provided a solution:
 https://developer.apple.com/forums/thread/699119
 I had to edit the current Xcode scheme, click "Run" in the left nav,
 and uncheck the "API Validation" checkbox
 in the Diagnostics ... Metal section.
 */
struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView

    let initialCenter: CLLocationCoordinate2D
    @Binding var currentCenter: CLLocationCoordinate2D?

    // This is required to conform to UIViewRepresentable.
    func makeUIView(context: Context) -> UIViewType {
        let mapView = UIViewType()
        mapView.delegate = context.coordinator

        let meters = 750.0
        mapView.region = MKCoordinateRegion(
            center: initialCenter,
            latitudinalMeters: meters,
            longitudinalMeters: meters
        )

        // Add a blue circle over the current user location.
        mapView.showsUserLocation = true

        return mapView
    }

    // This is called initially and again every time
    // ContentView passes a new value for `initialCenter`.
    @MainActor
    func updateUIView(_ mapView: UIViewType, context: Context) {
        mapView.centerCoordinate = initialCenter
    }

    // This is required to conform to UIViewRepresentable.
    func makeCoordinator() -> Coordinator {
        // Coordinator(self)
        Coordinator(center: $currentCenter)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        // Old approach:
        // var parent: MapView
        // init(_ parent: MapView) {
        //     self.parent = parent
        // }

        // New approach:
        @Binding var center: CLLocationCoordinate2D?
        init(center: Binding<CLLocationCoordinate2D?>) {
            // The underscore is needed to set the wrapped value of a Binding.
            _center = center
        }

        // This is called when the user drags the map.
        func mapViewDidChangeVisibleRegion(_ mapView: UIViewType) {
            print("new center =", mapView.centerCoordinate)
            Task { @MainActor in
                // Old approach:
                // parent.currentCenter = mapView.centerCoordinate

                // New approach:
                // TODO: Why does setting this break the ability to pan the map?
                // center = mapView.centerCoordinate
            }
        }
    }
}
