//
//  Alert.swift
//  OnTheMap
//
//  Created by Edward Morton on 7/8/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit

// MARK: alert

func alert(_ title: String, _ message: String, _ actions: [String], _ vc: UIViewController, completionHandler: @escaping (_ action: UIAlertAction?) -> Void) {
	let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

	for action in actions {
		alert.addAction(UIAlertAction(title: action, style: .default, handler: { (action) in
			completionHandler(action)
		}))
	}

	vc.present(alert, animated: true, completion: nil)
}
