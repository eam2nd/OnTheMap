//
//  Url.swift
//  OnTheMap
//
//  Created by Edward Morton on 7/7/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit

// MARK: isValidUrl

func isValidUrl(_ urlString: String?) -> Bool {
	if let urlString = urlString {
		if let url = URL(string: urlString) {
			return UIApplication.shared.canOpenURL(url) // needs protocol
		}
	}

	return false
}

// MARK: openValidUrl

func openValidUrl(_ urlString: String?) -> Void {
	if let urlString = urlString, isValidUrl(urlString), let url = URL(string: urlString) {
		if #available(iOS 10, *) {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		} else {
			UIApplication.shared.openURL(url)
		}
	}
}
