import MapKit
import SwiftUI

// For now we have to wrap an MKMapView in a UIViewRepresenatable
// in order to use the iOS 16 MapKit features in SwiftUI.
struct MapView: UIViewRepresentable {
    typealias ElevationStyle = MKMapConfiguration.ElevationStyle
    typealias EmphasisStyle = MKStandardMapConfiguration.EmphasisStyle
    typealias UIViewType = MKMapView

    var center: CLLocationCoordinate2D // holds lat/lng angles in degrees
    var distance: Double // in meters

    // This handles changes made in SettingsSheet.
    private func getConfig() -> MKMapConfiguration {
        MKImageryMapConfiguration(
            elevationStyle: ElevationStyle.realistic
        )
    }

    /// Computes a latitude angle from a latitude distance.
    /// - Parameters:
    ///   - latitude: span in meters
    /// - Returns: the latitude span angle in degrees
    private func latitudeAngle(
        latitudeMeters: Double
    ) -> Double {
        let earthCircumferenceThroughPoles = 40_007_863.0 // meters
        let metersPerDegree = earthCircumferenceThroughPoles / 360.0
        return latitudeMeters / metersPerDegree
    }

    /// Computes a longitude distance in meters.
    /// - Parameters:
    ///   - latitude: angle in degrees
    ///   - longitudeAngle: longitude span angle in degrees
    /// - Returns: the longitude span distance in meters
    private func longitudeMeters(
        latitude: Double,
        longitudeAngle: Double
    ) -> Double {
        let radiansPerDegree = Double.pi / 180.0
        let latRadians = latitude * radiansPerDegree
        let lngRadians = longitudeAngle * radiansPerDegree
        let earthRadius = 6_371_000.0 // average
        let earthDiameter = earthRadius * 2
        return earthDiameter * asin(cos(latRadians) * sin(lngRadians / 2))
    }

    // This is required to conform to UIViewRepresentable.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // This is required to conform to UIViewRepresentable.
    func makeUIView(context: Context) -> UIViewType {
        let mapView = UIViewType()
        mapView.delegate = context.coordinator

        // This adds a blue circle over the current user location.
        mapView.showsUserLocation = true

        mapView.camera = MKMapCamera(
            lookingAtCenter: center,
            fromDistance: distance,
            pitch: 0.0,
            heading: 0.0
        )

        return mapView
    }

    @MainActor
    func updateUIView(_ mapView: UIViewType, context _: Context) {
        // I was getting the error "The following Metal object is being
        // destroyed while still required to be alive by the command buffer".
        // This thread provided a solution:
        // https://developer.apple.com/forums/thread/699119
        // I had to edit the current Xcode scheme, click "Run" in the left nav,
        // and uncheck the "API Validation" checkbox in the "Metal" section.
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        // This is called when an annotation is tapped.
        // It allows displaying the name, phone number, address, and website
        // of the place associated with the annotation.
        @MainActor
        func mapView(
            _ mapView: UIViewType,
            didSelect annotation: MKAnnotation
        ) {}

        func mapView(_: UIViewType, regionDidChangeAnimated _: Bool) {}
    }
}
