import MapKit
import SwiftUI

// For now we have to wrap an MKMapView in a UIViewRepresenatable
// in order to use the iOS 16 MapKit features in SwiftUI.
struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView

    let initialCenter: CLLocationCoordinate2D
    @Binding var currentCenter: CLLocationCoordinate2D

    @State private var savedCenter: CLLocationCoordinate2D!

    // This is required to conform to UIViewRepresentable.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // This is required to conform to UIViewRepresentable.
    func makeUIView(context: Context) -> UIViewType {
        let mapView = UIViewType()
        mapView.delegate = context.coordinator

        // Add a blue circle over the current user location.
        mapView.showsUserLocation = true

        mapView.camera = MKMapCamera(
            lookingAtCenter: initialCenter,
            fromDistance: 2000.0,
            pitch: 0.0,
            heading: 0.0
        )
        Task { @MainActor in savedCenter = initialCenter }

        return mapView
    }

    @MainActor
    func updateUIView(_ mapView: UIViewType, context: Context) {
        // I was getting the error "The following Metal object is being
        // destroyed while still required to be alive by the command buffer".
        // This thread provided a solution:
        // https://developer.apple.com/forums/thread/699119
        // I had to edit the current Xcode scheme, click "Run" in the left nav,
        // and uncheck the "API Validation" checkbox
        // in the Diagnostics ... Metal section.

        if initialCenter != savedCenter {
            print("updateUIView: changing center to", initialCenter)
            Task { @MainActor in
                mapView.setCenter(initialCenter, animated: false)
                savedCenter = initialCenter
            }
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        // This is called when the user drags the map.
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            Task { @MainActor in
                parent.currentCenter = mapView.centerCoordinate
            }
        }
    }
}
