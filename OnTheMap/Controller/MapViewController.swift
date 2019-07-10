//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Edward Morton on 6/24/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit
import MapKit

// MARK: MapViewController Class - UIViewController, MKMapViewDelegate

class MapViewController: UIViewController, MKMapViewDelegate {

	// MARK: - Outlets

	@IBOutlet weak var mapView: MKMapView!

	// MARK: - View Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(putStudentsOnTheMap), name: .putStudentsOnTheMap, object: nil)
	}

	// MARK: - MKMapView - Delegate Methods

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		let reuseId = "pin"
		var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

		if pinView == nil {
			pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			pinView!.canShowCallout = true
			pinView!.pinTintColor = .red

			if let url = URL(string: annotation.subtitle! ?? ""), url.host != nil {
				pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
			}
		} else {
			pinView!.annotation = annotation
		}

		return pinView
	}

	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		if control == view.rightCalloutAccessoryView {
			openValidUrl(view.annotation?.subtitle ?? "")
		}
	}

	// MARK: - Methods

	@objc func putStudentsOnTheMap() {
		let students = StudentLocations.shared.studentLocations
		var annotations = [MKPointAnnotation]()

		mapView.removeAnnotations(mapView.annotations)

		for student in students {
			if let lat = student.latitude, let lng = student.longitude {
				let annotation = MKPointAnnotation()

				annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
				annotation.title = "\(student.firstName ?? "(First Name)") \(student.lastName ?? "(Last Name)")"
				annotation.subtitle = student.mediaURL

				annotations.append(annotation)
			}
		}

		mapView.addAnnotations(annotations)
		mapView.showAnnotations(mapView.annotations, animated: true)
	}
}
