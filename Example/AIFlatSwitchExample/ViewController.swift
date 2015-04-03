//
//  ViewController.swift
//  iOS Example
//
//  Created by cocoatoucher on 07/03/15.
//  Copyright (c) 2015 cocoatoucher. All rights reserved.
//

import UIKit
import AIFlatSwitch

class ViewController: UIViewController {
	
	@IBOutlet weak var flatSwitch: AIFlatSwitch!
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var bigFlatSwitch: AIFlatSwitch!
	@IBOutlet weak var smallFlatSwitch: AIFlatSwitch!
	@IBOutlet weak var programmaticSwitchContainer: UIView!
	var programmaticSwitch: AIFlatSwitch!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.programmaticSwitch = AIFlatSwitch(frame: CGRectMake(0, 0, 50, 50))
		self.programmaticSwitch.lineWidth = 2.0
		self.programmaticSwitch.strokeColor = UIColor.blueColor()
		self.programmaticSwitch.trailStrokeColor = UIColor.redColor().colorWithAlphaComponent(0.2)
		self.programmaticSwitch.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
		programmaticSwitchContainer.addSubview(programmaticSwitch)
		
		updateSwitchValue()
	}
	
	@IBAction func onSwitchValueChange(sender: AnyObject) {
		if sender as? AIFlatSwitch == flatSwitch {
			self.updateSwitchValue()
			
			bigFlatSwitch.setSelected(!bigFlatSwitch.selected, animated: true)
			smallFlatSwitch.selected = !smallFlatSwitch.selected
		}
	}
	
	func updateSwitchValue() {
		label.text = (flatSwitch.selected) ? NSLocalizedString("On", comment: "") : NSLocalizedString("Off", comment: "")
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

