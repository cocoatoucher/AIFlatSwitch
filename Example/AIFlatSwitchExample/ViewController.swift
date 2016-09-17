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
		
		self.programmaticSwitch = AIFlatSwitch(frame: CGRect(x: 0, y: 0, width: programmaticSwitchContainer.frame.width, height: programmaticSwitchContainer.frame.height))
		self.programmaticSwitch.lineWidth = 2.0
		self.programmaticSwitch.strokeColor = UIColor.blue
		self.programmaticSwitch.trailStrokeColor = UIColor.red.withAlphaComponent(0.2)
		self.programmaticSwitch.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		programmaticSwitchContainer.addSubview(programmaticSwitch)
		
		updateSwitchValue()
	}
	
	@IBAction func onSwitchValueChange(_ sender: AnyObject) {
		if sender as? AIFlatSwitch == flatSwitch {
			self.updateSwitchValue()
			
			bigFlatSwitch.setSelected(!bigFlatSwitch.isSelected, animated: true)
			smallFlatSwitch.isSelected = !smallFlatSwitch.isSelected
		}
	}
	
	func updateSwitchValue() {
		label.text = (flatSwitch.isSelected) ? NSLocalizedString("On", comment: "") : NSLocalizedString("Off", comment: "")
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

