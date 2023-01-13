import MapKit

extension CLLocationCoordinate2D: Equatable {
    // This is need in order to compare instances of this type.
    public static func == (
        lhs: CLLocationCoordinate2D,
        rhs: CLLocationCoordinate2D
    ) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
