//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Edward Morton on 7/5/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import Foundation

// MARK: performUIUpdatesOnMain

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
	DispatchQueue.main.async {
		updates()
	}
}
