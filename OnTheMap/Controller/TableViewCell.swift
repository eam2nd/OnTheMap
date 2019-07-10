//
//  TableViewCell.swift
//  OnTheMap
//
//  Created by Edward Morton on 7/5/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit

// MARK: TableViewCell Class - UITableViewCell

class TableViewCell: UITableViewCell {

	// MARK: - Outlets

	@IBOutlet weak var img: UIImageView!
	@IBOutlet weak var topLabel: UILabel!
	@IBOutlet weak var bottomLabel: UILabel!

	// MARK: - Methods

	func setContent(_ student: StudentInformation) {
		img.image = UIImage(named: "icon_pin")
		topLabel.text = "\(student.firstName ?? "(First Name)") \(student.lastName ?? "(Last Name)")"
		bottomLabel.text = student.mediaURL

		if isValidUrl(student.mediaURL ?? "") {
			self.accessoryType = .detailButton
		} else {
			self.accessoryType = .none
		}
	}
}
