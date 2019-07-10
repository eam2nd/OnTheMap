//
//  Udacity.swift
//  OnTheMap
//
//  Created by Edward Morton on 6/30/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

// MARK: Udacity Struct

struct Udacity {

	// MARK: - Properties

	struct UrlKeys {
		static let userId = "id"
	}

	struct Paths {
		static let userId = "/users/{id}" // get
		static let session = "/session" // post and delete
	}
}
