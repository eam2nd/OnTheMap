//
//  StudentLocations.swift
//  OnTheMap
//
//  Created by Edward Morton on 7/9/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

// MARK: - StudentLocations Struct

struct StudentLocations {

	// MARK: - Properties

	var studentLocations = [StudentInformation]()
	static var shared = StudentLocations()

	// MARK: - Initializer

	private init() {}

	// MARK: - Methods

	static func studentLocationsFromResults(_ results: [[String:AnyObject]]) -> [StudentInformation] {
		var locations = [StudentInformation]()

		for result in results {
			locations.append(StudentInformation(dictionary: result))
		}

		return locations
	}
}
