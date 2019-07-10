//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by Edward Morton on 7/5/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit

// MARK: TabBarViewController Class - UITabBarController

class TabBarViewController: UITabBarController {

	// MARK: - Outlets

	@IBOutlet weak var logoutButton: UIBarButtonItem!
	@IBOutlet weak var addLocationButton: UIBarButtonItem!
	@IBOutlet weak var refreshButton: UIBarButtonItem!

	// MARK: - Actions

	@IBAction func addLocation(_ sender: UIBarButtonItem) {
		configureUi(false)

		Client.sharedInstance().getStudent() { (objectId, error) in
			performUIUpdatesOnMain {
				self.configureUi(true)

				guard error == nil else {
					alert("Alert", error!.localizedDescription, ["OK"], self) { (action) in }
					return
				}

				guard objectId == nil else {
					alert("", "You Have Already Posted a Student Location.  Would You Like to Overwrite Your Current Location?", ["Overwrite", "Cancel"], self) { (action) in
						if let action = action, action.title == "Overwrite" {
							self.showSearchView()
						}
					}
					return
				}

				self.showSearchView()
			}
		}
	}

	@IBAction func refresh(_ sender: UIBarButtonItem) {
		getStudents()
	}

	@IBAction func logout(_ sender: UIBarButtonItem) {
		self.configureUi(false)

		Client.sharedInstance().logout() { (error) in
			performUIUpdatesOnMain {
				self.configureUi(true)

				guard error == nil else {
					alert("Alert", error!.localizedDescription, ["OK"], self) { (action) in }
					return
				}

				self.dismiss(animated: true, completion: nil)
			}
		}
	}

	// MARK: - Methods

	func showSearchView() {
		let controller = storyboard!.instantiateViewController(withIdentifier: "SearchNavigationController") as! UINavigationController
		self.present(controller, animated: true, completion: nil)
	}

	private func getStudents() {
		configureUi(false)

		Client.sharedInstance().getStudents() { (data, error) in
			performUIUpdatesOnMain {
				self.configureUi(true)

				guard error == nil else {
					alert("Alert", error!.localizedDescription, ["OK"], self) { (action) in }
					return
				}

				if let data = data {
					StudentLocations.shared.studentLocations = data
					NotificationCenter.default.post(name: .putStudentsOnTheMap, object: nil)
					NotificationCenter.default.post(name: .putStudentsOnTheList, object: nil)
				} else {
					alert("Alert", "getStudents: There was no data returned.", ["OK"], self) { (action) in }
				}
			}
		}
	}

	// MARK: - View Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		delegate = self
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		getStudents()
	}
}

// MARK: - TabBarViewController Extension - UITabBarControllerDelegate

extension TabBarViewController: UITabBarControllerDelegate  {

	// MARK: - Delegate Methods

	// Provide some animation moving between tabs
	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
		guard
			let fromVC = selectedViewController,
			let fromView = fromVC.view,
			let fromIndex = getIndex(forViewController: fromVC),
			let toView = viewController.view
			else {
				return false
		}

		var options: UIView.AnimationOptions = [.transitionFlipFromRight]

		if fromIndex == 1 {
			options = [.transitionFlipFromLeft]
		}

		// only animate if switching tabs
		if fromView != toView {
			UIView.transition(from: fromView, to: toView, duration: 0.35, options: options, completion: nil)
		}

		return true
	}

	// MARK: - Methods

	func getIndex(forViewController vc: UIViewController) -> Int? {
		guard let vcontrollers = self.viewControllers else {
			return nil
		}

		for (index, thisVC) in vcontrollers.enumerated() {
			if thisVC == vc {
				return index
			}
		}

		return nil
	}

	func configureUi(_ enabled: Bool) {
		logoutButton.isEnabled = enabled
		addLocationButton.isEnabled = enabled
		refreshButton.isEnabled = enabled

		if !enabled {
			Spinner.start(view)
		} else {
			Spinner.stop()
		}
	}
}
