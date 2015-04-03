//
//  AIFlatSwitchTests.swift
//  AIFlatSwitchTests
//
//  Created by cocoatoucher on 07/03/15.
//  Copyright (c) 2015 cocoatoucher. All rights reserved.
//

import UIKit
import XCTest

//Basic tests
class AIFlatSwitchTests: XCTestCase {
	
	var flatSwitch: AIFlatSwitch!
	
    override func setUp() {
        super.setUp()
		
		self.flatSwitch = AIFlatSwitch(frame: CGRectMake(0, 0, 50, 50))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testIsSelected() {
		self.flatSwitch.setSelected(true, animated: false)
		
		XCTAssertTrue(self.flatSwitch.selected, "Selected state should be true")
	}
	
	func testIsDeselected() {
		self.flatSwitch.setSelected(false, animated: false)
		
		XCTAssertFalse(self.flatSwitch.selected, "Selected state should be false")
	}
	
	func testIsSelectedAnimated() {
		self.flatSwitch.setSelected(true, animated: true)
		
		XCTAssertTrue(self.flatSwitch.selected, "Selected state should be true")
	}
	
	func testIsDeselectedAnimated() {
		self.flatSwitch.setSelected(false, animated: true)
		
		XCTAssertFalse(self.flatSwitch.selected, "Selected state should be false")
	}
    
}
