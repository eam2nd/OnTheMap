//
//  BorderedButton.swift
//  OnTheMap
//
//  Created by Edward Morton on 7/7/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit

// MARK: - BorderedButton: Button

class BorderedButton: UIButton {

	// MARK: - Properties

	// constants for styling and configuration
	let darkerBlue = UIColor(red: 0.0, green: 0.298, blue: 0.686, alpha:1.0)
	let lighterBlue = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
	let titleLabelFontSize: CGFloat = 17.0
	let borderedButtonHeight: CGFloat = 44.0
	let borderedButtonCornerRadius: CGFloat = 4.0
	let phoneBorderedButtonExtraPadding: CGFloat = 14.0

	var backingColor: UIColor? = nil
	var highlightedBackingColor: UIColor? = nil

	// MARK: - Initializer

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		themeBorderedButton()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		themeBorderedButton()
	}

	private func themeBorderedButton() {
		layer.masksToBounds = true
		layer.cornerRadius = borderedButtonCornerRadius
		highlightedBackingColor = darkerBlue
		backingColor = lighterBlue
		backgroundColor = lighterBlue
		setTitleColor(.white, for: UIControl.State())
		titleLabel?.font = UIFont.systemFont(ofSize: titleLabelFontSize)
	}

	// MARK: - Setters

	private func setBackingColor(_ newBackingColor: UIColor) {
		if let _ = backingColor {
			backingColor = newBackingColor
			backgroundColor = newBackingColor
		}
	}

	private func setHighlightedBackingColor(_ newHighlightedBackingColor: UIColor) {
		highlightedBackingColor = newHighlightedBackingColor
		backingColor = highlightedBackingColor
	}

	// MARK: - Tracking

	override func beginTracking(_ touch: UITouch, with withEvent: UIEvent?) -> Bool {
		backgroundColor = highlightedBackingColor
		return true
	}

	override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
		backgroundColor = backingColor
	}

	override func cancelTracking(with event: UIEvent?) {
		backgroundColor = backingColor
	}

	// MARK: - Layout

	override func sizeThatFits(_ size: CGSize) -> CGSize {
		let extraButtonPadding : CGFloat = phoneBorderedButtonExtraPadding
		var sizeThatFits = CGSize.zero
		sizeThatFits.width = super.sizeThatFits(size).width + extraButtonPadding
		sizeThatFits.height = borderedButtonHeight
		return sizeThatFits
	}

	// MARK: - isEnabled

	override var isEnabled: Bool {
		didSet {
			if !isEnabled {
				highlightedBackingColor = UIColor.darkGray
				backingColor = UIColor.darkGray
				backgroundColor = UIColor.lightGray
			} else {
				highlightedBackingColor = darkerBlue
				backingColor = lighterBlue
				backgroundColor = lighterBlue
			}
		}
	}
}
