//
//  Spinner.swift
//  OnTheMap
//
//  Created by Edward Morton on 7/8/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit

// MARK: Spinner Struct

struct Spinner {

	// MARK: - Properties

	private static var container: UIView = UIView()
	private static var loader: UIView = UIView()
	private static var spinner: UIActivityIndicatorView = UIActivityIndicatorView()

	// MARK: - Methods

	static func start(_ view: UIView) {
		container.frame = view.frame
		container.center = view.center
		container.backgroundColor = hexToUiColor(0xffffff, 0.3)

		loader.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
		loader.center = view.center
		loader.backgroundColor = hexToUiColor(0x555555, 0.7)
		loader.clipsToBounds = true
		loader.layer.cornerRadius = 10

		spinner.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
		spinner.center = CGPoint(x: loader.frame.size.width / 2, y: loader.frame.size.height / 2);
		spinner.style = .whiteLarge

		loader.addSubview(spinner)
		container.addSubview(loader)
		view.addSubview(container)

		spinner.startAnimating()
	}

	static func stop() {
		spinner.stopAnimating()
		container.removeFromSuperview()
	}

	static func hexToUiColor(_ rgbValue: UInt32, _ alpha: Double = 1.0) -> UIColor {
		let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 256.0
		let green = CGFloat((rgbValue & 0xFF00) >> 8) / 256.0
		let blue = CGFloat(rgbValue & 0xFF) / 256.0

		return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
	}
}
