//
//  Client.swift
//  OnTheMap
//
//  Created by Edward Morton on 6/30/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import Foundation

// MARK: Client Class - NSObject

class Client: NSObject {

	// MARK: - Properties

	var session = URLSession.shared

	// Udacity
	var accountKey: String? = nil
	var sessionId: String? = nil

	// Parse
	var objectId: String? = nil

	// MARK: - Initializer

	override init() {
		super.init()
	}

	// MARK: - Methods

	func taskForGetMethod(_ api: String, _ pathExtension: String, _ parameters: [String:AnyObject], completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
		// 1. Set the parameters
		var localParameters = parameters

		// 2&3. Build the URL, Configure the request
		let url = getUrlWithParameters(localParameters, pathExtension)
		let request = NSMutableURLRequest(url: url)

		// 4. Make the request
		let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
			func sendError(_ error: String) {
				let userInfo = [NSLocalizedDescriptionKey : error]
				completionHandler(nil, NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
			}

			// GUARD: Was there an error?
			guard (error == nil) else {
				sendError("There was an error with your request: \(error!)")
				return
			}

			// GUARD: Did we get a successful 2XX response?
			guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
				sendError("Your request returned a status code other than 2xx!")
				return
			}

			// GUARD: Was there any data returned?
			guard let data = data else {
				sendError("No data was returned by the request!")
				return
			}

			// 5&6. Parse the data and use the data (happens in completion handler)
			self.convertDataWithCompletionHandler(api, data, completionHandlerForConvertData: completionHandler)
		}

		// 7. Start the request
		task.resume()

		return task
	}

	func taskForPostMethod(_ api: String, _ pathExtension: String, _ parameters: [String:AnyObject], _ requestBody: String, completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
		// 1. Set the parameters
		var localParameters = parameters

		// 2&3. Build the URL, Configure the request
		let url = getUrlWithParameters(localParameters, pathExtension)
		let request = NSMutableURLRequest(url: url)

		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = requestBody.data(using: .utf8)

		// 4. Make the request
		let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
			func sendError(_ error: String) {
				let userInfo = [NSLocalizedDescriptionKey : error]
				completionHandler(nil, NSError(domain: "taskForPostMethod", code: 1, userInfo: userInfo))
			}

			// GUARD: Was there an error?
			guard (error == nil) else {
				sendError("There was an error with your request: \(error!)")
				return
			}

			// GUARD: Did we get a successful 2XX response? Or was it a login attempt with a 403 repsonse?
			guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (statusCode >= 200 && statusCode <= 299 || (pathExtension == Udacity.Paths.session && statusCode == 403)) else {
				sendError("Your request returned a status code other than 2xx!")
				return
			}

			// GUARD: Was there any data returned?
			guard let data = data else {
				sendError("No data was returned by the request!")
				return
			}

			// 5&6. Parse the data and use the data (happens in completion handler)
			self.convertDataWithCompletionHandler(api, data, completionHandlerForConvertData: completionHandler)
		}

		// 7. Start the request
		task.resume()

		return task
	}

	func taskForPutMethod(_ api: String, _ pathExtension: String, _ parameters: [String:AnyObject], _ requestBody: String, completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
		// 1. Set the parameters
		var localParameters = parameters

		// 2&3. Build the URL, Configure the request
		let url = getUrlWithParameters(localParameters, pathExtension)
		let request = NSMutableURLRequest(url: url)

		request.httpMethod = "PUT"
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = requestBody.data(using: String.Encoding.utf8)

		// 4. Make the request
		let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
			func sendError(_ error: String) {
				let userInfo = [NSLocalizedDescriptionKey : error]
				completionHandler(nil, NSError(domain: "taskForPostMethod", code: 1, userInfo: userInfo))
			}

			// GUARD: Was there an error?
			guard (error == nil) else {
				sendError("There was an error with your request: \(error!)")
				return
			}

			// GUARD: Did we get a successful 2XX response?
			guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
				sendError("Your request returned a status code other than 2xx!")
				return
			}

			// GUARD: Was there any data returned?
			guard let data = data else {
				sendError("No data was returned by the request!")
				return
			}

			// 5&6. Parse the data and use the data (happens in completion handler)
			self.convertDataWithCompletionHandler(api, data, completionHandlerForConvertData: completionHandler)
		}

		// 7. Start the request
		task.resume()

		return task
	}

	func taskForDeleteMethod(_ api: String, _ pathExtension: String, _ parameters: [String:AnyObject], completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
		// 1. Set the parameters
		var localParameters = parameters

		// 2&3. Build the URL, Configure the request
		let url = getUrlWithParameters(localParameters, pathExtension)
		let request = NSMutableURLRequest(url: url)

		request.httpMethod = "DELETE"

		var xsrfCookie: HTTPCookie? = nil
		let sharedCookieStorage = HTTPCookieStorage.shared

		for cookie in sharedCookieStorage.cookies! {
			if cookie.name == "XSRF-TOKEN" {
				xsrfCookie = cookie
				break
			}
		}

		if let xsrfCookie = xsrfCookie {
			request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
		}

		// 4. Make the request
		let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
			func sendError(_ error: String) {
				let userInfo = [NSLocalizedDescriptionKey : error]
				completionHandler(nil, NSError(domain: "taskForDeleteMethod", code: 1, userInfo: userInfo))
			}

			// GUARD: Was there an error?
			guard (error == nil) else {
				sendError("There was an error with your request: \(error!)")
				return
			}

			// GUARD: Did we get a successful 2XX response?
			guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
				sendError("Your request returned a status code other than 2xx!")
				return
			}

			// GUARD: Was there any data returned?
			guard let data = data else {
				sendError("No data was returned by the request!")
				return
			}

			// 5&6. Parse the data and use the data (happens in completion handler)
			self.convertDataWithCompletionHandler(api, data, completionHandlerForConvertData: completionHandler)
		}

		// 7. Start the request
		task.resume()

		return task
	}

	// create a URL from parameters
	func getUrlWithParameters(_ parameters: [String:AnyObject], _ withPathExtension: String? = nil) -> URL {
		var components = URLComponents()

		components.scheme = Constants.scheme
		components.host = Constants.host
		components.path = Constants.path + (withPathExtension ?? "")
		components.queryItems = [URLQueryItem]()

		for (key, value) in parameters {
			let queryItem = URLQueryItem(name: key, value: "\(value)")
			components.queryItems!.append(queryItem)
		}

		return components.url!
	}

	// substitute the key for the value that is contained within the method name
	func substituteKeyInMethod(_ pathExtension: String, key: String, value: String) -> String? {
		if pathExtension.range(of: "{\(key)}") != nil {
			return pathExtension.replacingOccurrences(of: "{\(key)}", with: value)
		} else {
			return nil
		}
	}

	// given raw JSON, return a usable Foundation object
	private func convertDataWithCompletionHandler(_ api: String, _ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
		var parsedResult: AnyObject? = nil
		var localData = data

		if api == "udacity" {
			localData = data.subdata(in: 5..<data.count)
		}

		do {
			parsedResult = try JSONSerialization.jsonObject(with: localData, options: .allowFragments) as AnyObject
		} catch {
			let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
			completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
		}

		completionHandlerForConvertData(parsedResult, nil)
	}

	// MARK: - Shared Instance

	class func sharedInstance() -> Client {
		struct Singleton {
			static var sharedInstance = Client()
		}

		return Singleton.sharedInstance
	}
}
