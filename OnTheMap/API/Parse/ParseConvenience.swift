//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Edward Morton on 6/30/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import Foundation

// MARK: Client Extension - Parse

extension Client {

	// MARK: - Methods

	func getStudents(_ completionHandler: @escaping (_ locations: [StudentInformation]?, _ error: NSError?) -> Void) {
		// 1: Set the parameters
		let parameters = [Parse.Parameters.Keys.limit: Parse.Parameters.Values.limit, Parse.Parameters.Keys.order: Parse.Parameters.Values.order]

		// 2: Make the request
		_ = taskForGetMethod("parse", Parse.Paths.studentLocations, parameters as [String: AnyObject]) { (results, error) in
			guard error == nil else {
				completionHandler(nil, error)
				return
			}

			if let dictionary = results?["results"] as? [[String : AnyObject]] {
				let locations = StudentLocations.studentLocationsFromResults(dictionary)
				completionHandler(locations, nil)
			} else {
				completionHandler(nil, NSError(domain: "getStudents", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse results."]))
			}
		}
	}

	func getStudent(_ completionHandler: @escaping (_ objectId: String?, _ error: NSError?) -> Void) {
		// 1: Set the parameters
		let parameters = [Parse.Parameters.Keys.uniqueKey: Client.sharedInstance().accountKey, Parse.Parameters.Keys.limit: Parse.Parameters.Values.limit, Parse.Parameters.Keys.order: Parse.Parameters.Values.order]

		// 2: Make the request
		_ = taskForGetMethod("parse", Parse.Paths.studentLocations, parameters as [String: AnyObject]) { (results, error) in
			guard error == nil else {
				completionHandler(nil, error)
				return
			}

			if let dictionary = results?["results"] as? [[String : AnyObject]] {
				let locations = StudentLocations.studentLocationsFromResults(dictionary)

				if let objectId = locations[0].objectId {
					Client.sharedInstance().objectId = objectId
				} else {
					Client.sharedInstance().objectId = nil
				}
			}

			completionHandler(Client.sharedInstance().objectId, nil)
		}
	}

	func postStudent(_ requestBody: String, _ completionHandler: @escaping (_ error: NSError?) -> Void) {
		// 1: Set the parameters
		let parameters = [String:AnyObject]()

		// 2: Make the request
		_ = taskForPostMethod("parse", Parse.Paths.studentLocations, parameters, requestBody) { (results, error) in
			completionHandler(error)
		}
	}

	func putStudent(_ requestBody: String, _ completionHandler: @escaping (_ error: NSError?) -> Void) {
		// 1: Set the parameters
		let parameters = [String:AnyObject]()
		var pathExtension: String = Parse.Paths.studentLocation

		pathExtension = substituteKeyInMethod(pathExtension, key: Parse.UrlKeys.objectId, value: self.objectId!)!

		// 2: Make the request
		_ = taskForPutMethod("parse", pathExtension, parameters, requestBody) { (results, error) in
			completionHandler(error)
		}
	}
}
