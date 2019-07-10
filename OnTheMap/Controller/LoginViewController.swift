//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Edward Morton on 7/1/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit

// MARK: LoginViewController Class - UIViewController, UITextFieldDelegate

class LoginViewController: UIViewController, UITextFieldDelegate {

	// MARK: - Properties

	var textFieldYPosition: CGFloat = 0.0

	// MARK: - Outlets

	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var signUpButton: UIButton!
	
	// MARK: - Actions

	@IBAction func login(_ sender: UIButton) {
		guard !usernameTextField.text!.isEmpty, !passwordTextField.text!.isEmpty else {
			alert("Alert", "Email and Passward are required.", ["OK"], self) { (action) in }
			return
		}

		configureUi(false)

		Client.sharedInstance().login(usernameTextField.text!, passwordTextField.text!) { (error) in
			guard error == nil else {
				performUIUpdatesOnMain {
					self.configureUi(true)
					alert("Alert", "There was a problem logging in:\n\n \(error!.localizedDescription)", ["OK"], self) { (action) in }
				}
				return
			}

			performUIUpdatesOnMain {
				self.loggedIn()
				self.configureUi(true)
			}
		}
	}

	@IBAction func signUp(_ sender: UIButton) {
		// openValidUrl("https://www.udacity.com/account/auth%23!/signup&sa=D&ust=1561426630219000")
		openValidUrl("https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated")
	}

	// MARK: - Methods

	private func loggedIn() {
		let controller = storyboard!.instantiateViewController(withIdentifier: "TabBarNavigationController") as! UINavigationController

		present(controller, animated: true, completion: nil)
	}

	// MARK: - View Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		usernameTextField.delegate = self
		passwordTextField.delegate = self
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

		if usernameTextField.isEditing {
			usernameTextField.endEditing(true)
		} else if passwordTextField.isEditing {
			passwordTextField.endEditing(true)
		}
	}
}

// MARK: - LoginViewController Extension

extension LoginViewController {

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
		usernameTextField.isEnabled = enabled
		passwordTextField.isEnabled = enabled
		loginButton.isEnabled = enabled

		if usernameTextField.isEditing {
			usernameTextField.endEditing(true)
		}

		if passwordTextField.isEditing {
			passwordTextField.endEditing(true)
		}

		if !enabled {
			Spinner.start(view)
		} else {
			Spinner.stop()
		}
	}
}
