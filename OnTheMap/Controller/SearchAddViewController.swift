//
//  SearchAddViewController.swift
//  OnTheMap
//
//  Created by Edward Morton on 7/7/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit
import MapKit

// MARK: SearchAddViewController Class - UIViewController, UITextFieldDelegate

class SearchAddViewController: UIViewController, UITextFieldDelegate {

	// MARK: - Properties

	var textFieldYPosition: CGFloat = 0.0
	var latitude: Double?
	var longitude: Double?

	// MARK: - Outlets

	@IBOutlet weak var locationTextField: UITextField!
	@IBOutlet weak var urlTextField: UITextField!
	@IBOutlet weak var searchButton: UIButton!

	// MARK: - Actions

	@IBAction func searchLocation(_ sender: UIButton) {
		configureUi(false)

		guard let locationString = locationTextField.text, !locationString.isEmpty else {
			configureUi(true)
			alert("Alert", "Location is required.", ["OK"], self) { (action) in }
			return
		}

		guard let urlString = urlTextField.text, !urlString.isEmpty, isValidUrl(urlString) else {
			configureUi(true)
			alert("Alert", "The website you provided is not valid.", ["OK"], self) { (action) in }
			return
		}

		let request = MKLocalSearch.Request()
		request.naturalLanguageQuery = locationTextField.text
		let search = MKLocalSearch(request: request)

		search.start { (response, error) in
			guard (error == nil) else {
				self.configureUi(true)
				alert("Alert", "There was an error with the location search:\n\n \(error!.localizedDescription)", ["OK"], self) { (action) in }
				return
			}

			self.latitude = response?.boundingRegion.center.latitude
			self.longitude = response?.boundingRegion.center.longitude
			self.performSegue(withIdentifier: "searchFinish", sender: nil)
			self.configureUi(true)
		}
	}

	@IBAction func cancel(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}

	// MARK: - Methods

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "searchFinish" {
			let vc = segue.destination as! SearchFinishViewController

			vc.mapString = locationTextField.text
			vc.mediaURL = urlTextField.text
			vc.latitude = latitude
			vc.longitude = longitude
		}
	}

	// MARK: - View Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		locationTextField.delegate = self
		urlTextField.delegate = self
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		subscribeToKeyboardNotifications()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		unsubscribeFromKeyboardNotifications()
	}

	// dismiss keyboard on orientation change when editing bottom textfield
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)

		if locationTextField.isEditing {
			locationTextField.endEditing(true)
		} else if urlTextField.isEditing {
			urlTextField.endEditing(true)
		}
	}
}

// MARK: - SearchAddViewController Extension

extension SearchAddViewController {

	// MARK: - TextField Delegate Methods

	func textFieldDidBeginEditing(_ textField: UITextField) {
		textFieldYPosition = textField.frame.origin.y + textField.frame.height
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}

	// MARK: - Keyboard Notification Methods

	func subscribeToKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}

	func unsubscribeFromKeyboardNotifications() {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}

	@objc func keyboardWillShow(_ notification: Notification) {
		let keyboardHeight = getKeyboardHeight(notification)
		let delta = self.view.frame.height - textFieldYPosition - keyboardHeight

		if delta < 0 {
			UIView.animate(withDuration: 0.4) {
				self.view.transform = CGAffineTransform(translationX: 0.0, y: delta)
			}
		}
	}

	@objc func keyboardWillHide(_ notification: Notification) {
		UIView.animate(withDuration: 0.4) {
			self.view.transform = .identity
		}
	}

	func getKeyboardHeight(_ notification:Notification) -> CGFloat {
		let userInfo = notification.userInfo
		let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
		return keyboardSize.cgRectValue.height
	}

	// MARK: - Methods

	func configureUi(_ enabled: Bool) {
		locationTextField.isEnabled = enabled
		urlTextField.isEnabled = enabled
		searchButton.isEnabled = enabled

		if locationTextField.isEditing {
			locationTextField.endEditing(true)
		}

		if urlTextField.isEditing {
			urlTextField.endEditing(true)
		}

		if !enabled {
			Spinner.start(view)
		} else {
			Spinner.stop()
		}
	}
}
