//
//  SearchFinishViewController.swift
//  OnTheMap
//
//  Created by Edward Morton on 7/7/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit
import MapKit

// MARK: SearchFinishViewController Class - UIViewController

class SearchFinishViewController: UIViewController {

	// MARK: - Properties

	var mapString: String?
	var mediaURL: String?
	var latitude: Double?
	var longitude: Double?

	// MARK: - Outlets

	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var finishButton: BorderedButton!

	// MARK: - Actions

	@IBAction func finish(_ sender: Any) {
		configureUi(false)

		if Client.sharedInstance().objectId == nil {
			addLocation()
		} else {
			updateLocation()
		}
	}

	// MARK: - View Life Cycle

	override func viewWillAppear(_ animated: Bool) {
		updateMap()
	}

	// MARK: - Methods

	func updateMap() {
		let annotation = MKPointAnnotation()

		if let lat = latitude, let lng = longitude, let title = mapString, let subtitle = mediaURL {
			let coordinate = CLLocationCoordinate2DMake(lat, lng)

			annotation.coordinate = coordinate
			annotation.title = title
			annotation.subtitle = subtitle
			mapView.addAnnotation(annotation)

			// center map on marker and zoom in
			let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
			let region = MKCoordinateRegion(center: coordinate, span: span)

			mapView.setRegion(region, animated: true)
		} else {
			alert("Alert", "Missing map data!", ["OK"], self) { (action) in }
		}
	}

	func addLocation() {
		// get user first and last name
		Client.sharedInstance().getUser() { (firstName, lastName, error) in
			guard error == nil else {
				performUIUpdatesOnMain {
					self.configureUi(true)
					alert("Alert", "Could not retrieve user data:\n\n \(error!.localizedDescription)", ["OK"], self) { (action) in }
				}
				return
			}

			// create request body
			let requestBody = "{\"uniqueKey\": \"\(Client.sharedInstance().accountKey!)\", \"firstName\": \"\(firstName ?? "")\", \"lastName\": \"\(lastName ?? "")\", \"mapString\": \"\(self.mapString ?? "")\", \"mediaURL\": \"\(self.mediaURL ?? "")\", \"latitude\": \(self.latitude ?? 0), \"longitude\": \(self.longitude ?? 0)}"

			// post data
			Client.sharedInstance().postStudent(requestBody) { (error) in
				guard error == nil else {
					performUIUpdatesOnMain {
						self.configureUi(true)
						alert("Alert", "An error occurred posting data:\n\n \(error!.localizedDescription)", ["OK"], self) { (action) in }
					}
					return
				}

				self.done()
			}
		}
	}

	func updateLocation() {
		// get user first and last name
		Client.sharedInstance().getUser() { (firstName, lastName, error) in
			guard error == nil else {
				performUIUpdatesOnMain {
					self.configureUi(true)
					alert("Alert", "Could not retrieve user data:\n\n \(error!.localizedDescription)", ["OK"], self) { (action) in }
				}
				return
			}

			// create request body
			let requestBody = "{\"uniqueKey\": \"\(Client.sharedInstance().accountKey!)\", \"firstName\": \"\(firstName ?? "")\", \"lastName\": \"\(lastName ?? "")\", \"mapString\": \"\(self.mapString ?? "")\", \"mediaURL\": \"\(self.mediaURL ?? "")\", \"latitude\": \(self.latitude ?? 0), \"longitude\": \(self.longitude ?? 0)}"

			// put data
			Client.sharedInstance().putStudent(requestBody) { (error) in
				guard error == nil else {
					performUIUpdatesOnMain {
						self.configureUi(true)
						alert("Alert", "An error occurred putting data:\n\n \(error!.localizedDescription)", ["OK"], self) { (action) in }
					}
					return
				}

				self.done()
			}
		}
	}

	func done() {
		performUIUpdatesOnMain {
			self.configureUi(true)

			if let navController = self.navigationController {
				navController.dismiss(animated: true, completion: nil)
			}
		}
	}
}

// MARK: - SearchFinishViewController Extension

extension SearchFinishViewController {

	// MARK: - Methods

	func configureUi(_ enabled: Bool) {
		finishButton.isEnabled = enabled

		if !enabled {
			Spinner.start(view)
		} else {
			Spinner.stop()
		}
	}
}
