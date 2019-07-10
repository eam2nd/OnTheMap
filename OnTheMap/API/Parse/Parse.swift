//
//  Parse.swift
//  OnTheMap
//
//  Created by Edward Morton on 6/30/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

// MARK: Parse Struct

struct Parse {

	// MARK: - Properties

	struct UrlKeys {
		static let objectId = "id"
	}

	struct Paths {
		static let studentLocations = "/StudentLocation" // get and post
		static let studentLocation = "/StudentLocation/{id}"// put
	}

	struct Parameters {
		struct Keys {
			static let limit = "limit" // (Number) specifies the maximum number of StudentLocation objects to return in the JSON response
			static let skip = "skip" // (Number) use this parameter with limit to paginate through results
			static let order = "order" // (String) a comma-separate list of key names that specify the sorted order of the results
			static let uniqueKey = "uniqueKey" // (String) a unique key (user ID). Gets only student locations with a given user ID.
		}

		struct Values {
			static let limit = "100"
			static let skip = "1"
			static let order = "-updatedAt"
			static let uniqueKey = "{\"uniqueKey\":\"{id}\"}"
		}
	}
}
