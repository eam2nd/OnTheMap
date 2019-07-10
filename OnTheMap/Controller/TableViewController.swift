//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Edward Morton on 7/5/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit

// MARK: TableViewController Class - UITableViewController

class TableViewController: UITableViewController {

	// MARK: - View Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(putStudentsOnTheList), name: .putStudentsOnTheList, object: nil)
	}

	// MARK: - UITableView - Delegate Methods

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return StudentLocations.shared.studentLocations.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell

		cell.setContent(StudentLocations.shared.studentLocations[(indexPath as NSIndexPath).row])

		return cell
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 85
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		openStudentUrl(indexPath)
	}

	override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		openStudentUrl(indexPath)
	}

	// MARK: - Methods

	private func openStudentUrl (_ indexPath: IndexPath) {
		if let student = StudentLocations.shared.studentLocations[indexPath.row] as StudentInformation? {
			openValidUrl(student.mediaURL ?? "")
		}
	}

	@objc func putStudentsOnTheList() {
		tableView.reloadData()
	}
}
