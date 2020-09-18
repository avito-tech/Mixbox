import UIKit
import MixboxUiKit
import TestsIpc
import MapKit
import MixboxFoundation

final class NonViewElementsTestsMapView: UIView, TestingView, MKMapViewDelegate {
    private let coordinate = CLLocationCoordinate2D(
        latitude: 54.419925,
        longitude: 56.782485
    )
    private let mapView = MKMapView(frame: .zero)
    private let layoutOnceToken = ThreadUnsafeOnceToken<Void>()
    
    init(testingViewControllerSettings: TestingViewControllerSettings) {
        super.init(frame: .zero)
        
        backgroundColor = .white

        mapView.accessibilityIdentifier = "map"
        mapView.delegate = self
        addSubview(mapView)
        
        let annotation = MKPointAnnotation()
        
        annotation.title = "PinTitle"
        annotation.coordinate = coordinate
        
        mapView.addAnnotation(annotation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mapView.frame = bounds
        
        layoutMapOnce()
    }
    
    private func layoutMapOnce() {
        layoutOnceToken.executeOnce {
            layoutMap()
        }
    }
        
    private func layoutMap() {
        do {
            let region = MKCoordinateRegion(
                center: coordinate,
                latitudinalMeters: try CLLocationDistance(exactly: 300).unwrapOrThrow(),
                longitudinalMeters: try CLLocationDistance(exactly: 300).unwrapOrThrow()
            )
            mapView.setRegion(mapView.regionThatFits(region), animated: false)
            mapView.mapType = .satellite
        } catch {
            assertionFailure("\(error)")
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "PinIdentifier"
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView.annotation = annotation
            return annotationView
        } else {
            let annotationView = MKPinAnnotationView(
                annotation: annotation,
                reuseIdentifier: identifier
            )
            annotationView.accessibilityIdentifier = "pin"
            annotationView.canShowCallout = true
            
            return annotationView
        }
    }
}
