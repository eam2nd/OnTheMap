//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Edward Morton on 7/1/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import Foundation

// MARK: Client Extension - Udacity

extension Client {

	// MARK: - Methods

	func login(_ username: String, _ password: String, completionHandler: @escaping (_ error: NSError?) -> Void) {
		// 1: Set the parameters
		let parameters = [String:AnyObject]()
		let requestBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"

		// 2: Make the request
		_ = taskForPostMethod( "udacity", Udacity.Paths.session, parameters, requestBody) { (results, error) in
			guard error == nil else {
				completionHandler(error)
				return
			}

			if let account = results?["account"] as? [String:AnyObject], let session = results?["session"] as? [String:AnyObject] {
				let accountKey = account["key"] as? String
				let sessionId = session["id"] as? String

				self.sessionId = sessionId
				self.accountKey = accountKey
				completionHandler(nil)
			} else if let resultError = results?["error"] as? String {
				completionHandler(NSError(domain: "login", code: 1, userInfo: [NSLocalizedDescriptionKey: resultError]))
			} else {
				completionHandler(NSError(domain: "login", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse results."]))
			}
		}
	}

	func logout (_ completionHandler: @escaping (_ error: NSError?) -> Void) {
		// 1: Set the parameters
		let parameters = [String:AnyObject]()

		// 2: Make the request
		_ = taskForDeleteMethod("udacity", Udacity.Paths.session, parameters) { (results, error) in
			guard error == nil else {
				completionHandler(error)
				return
			}

			self.accountKey = nil
			self.sessionId = nil
			completionHandler(nil)
		}
	}

	func getUser(_ completionHandler: @escaping (_ firstName: String?,_ lastName: String?, _ error: NSError?) -> Void) {
		// 1: Set the parameters
		let parameters = [String:AnyObject]()
		let pathExtension = substituteKeyInMethod(Udacity.Paths.userId, key: Udacity.UrlKeys.userId, value: Client.sharedInstance().accountKey ?? "")!

		// 2: Make the request
		_ = taskForGetMethod("udacity", pathExtension, parameters) { (results, error) in
			guard error == nil else {
				completionHandler(nil, nil, error)
				return
			}

			// this seems to work
			if let dictionary = results as? [String : AnyObject] {
				if let firstName = dictionary["first_name"] as? String, let lastName = dictionary["last_name"] as? String {
					completionHandler(firstName, lastName, nil)
				} else {
					completionHandler("(First Name)", "(Last Name)", nil)
				}
			// this doesn't work, but is what you see in a browser response, so maybe
			} else if let dictionary = results?["user"] as? [[String : AnyObject]] {
				if let firstName = dictionary[0]["first_name"] as? String, let lastName = dictionary[0]["last_name"] as? String {
					completionHandler(firstName, lastName, nil)
				} else {
					completionHandler("(First Name)", "(Last Name)", nil)
				}
			} else {
				completionHandler(nil, nil, NSError(domain: "getUser", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse results."]))
			}
		}
	}
}
