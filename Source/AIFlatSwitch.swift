//
//  AIFlatSwitch.swift
//  AIFlatSwitch
//
//  Created by cocoatoucher on 11/02/15.
//  Copyright (c) 2015 cocoatoucher. All rights reserved.
//

import UIKit

/**
	A flat design switch alternative to UISwitch
*/
@IBDesignable open class AIFlatSwitch: UIControl {
	
	/**
		Animation duration for the whole selection transition
	*/
	fileprivate let animationDuration: CFTimeInterval = 0.3
	/**
		Percentage where the checkmark tail ends
	*/
	fileprivate let finalStrokeEndForCheckmark: CGFloat = 0.85
	/**
		Percentage where the checkmark head begins
	*/
	fileprivate let finalStrokeStartForCheckmark: CGFloat = 0.3
	/**
		Percentage of the bounce amount of checkmark near animation completion
	*/
	fileprivate let checkmarkBounceAmount: CGFloat = 0.1
	
	/**
		Line width for the circle, trail and checkmark parts of the switch.
	*/
	@IBInspectable open var lineWidth: CGFloat = 2.0 {
		didSet {
			self.circle.lineWidth = lineWidth
			self.checkmark.lineWidth = lineWidth
			self.trailCircle.lineWidth = lineWidth
		}
	}
	
	/**
		Set to false if the selection should not be animated with touch up inside events.
	*/
	@IBInspectable open var animatesOnTouch: Bool = true
	
	/**
		Stroke color for circle and checkmark.
		Circle disappears and trail becomes visible when the switch is selected.
	*/
	@IBInspectable open var strokeColor: UIColor = UIColor.black {
		didSet {
			self.circle.strokeColor = strokeColor.cgColor
			self.checkmark.strokeColor = strokeColor.cgColor
		}
	}
	
	/**
		Stroke color for trail.
		Trail disappears and circle becomes visible when the switch is deselected.
	*/
	@IBInspectable open var trailStrokeColor: UIColor = UIColor.gray {
		didSet {
			self.trailCircle.strokeColor = trailStrokeColor.cgColor
		}
	}
	
	/**
		Overrides isSelected from UIControl using internal state flag.
		Default value is false.
	*/
	@IBInspectable open override var isSelected: Bool {
		get {
			return isSelectedInternal
		}
		set {
			super.isSelected = newValue
			self.setSelected(newValue, animated: false)
		}
	}
	
	/**
		Internal flag to keep track of selected state.
	*/
	fileprivate var isSelectedInternal: Bool = false
	
	/**
		Trail layer. Trail is the circle which appears when the switch is in deselected state.
	*/
	fileprivate var trailCircle: CAShapeLayer = CAShapeLayer()
	/**
		Circle layer. Circle appears when the switch is in selected state.
	*/
	fileprivate var circle: CAShapeLayer = CAShapeLayer()
	/**
		Checkmark layer. Checkmark appears when the switch is in selected state.
	*/
	fileprivate var checkmark: CAShapeLayer = CAShapeLayer()
	
	/**
		Middle point of the checkmark layer. Calculated each time the sublayers are layout.
	*/
	fileprivate var checkmarkSplitPoint: CGPoint = CGPoint.zero
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		// Configure switch when created with frame
		self.configure()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		// Configure switch when created from xib
		self.configure()
	}
	
	/**
		Configures circle, trail and checkmark layers after initialization.
		Setups switch with the default selection state. 
		Configures target for tocuh up inside event for triggering selection.
	*/
	fileprivate func configure() {
		
		func configureShapeLayer(_ shapeLayer: CAShapeLayer) {
			shapeLayer.lineJoin = kCALineJoinRound
			shapeLayer.lineCap = kCALineCapRound
			shapeLayer.lineWidth = self.lineWidth
			shapeLayer.fillColor = UIColor.clear.cgColor
			self.layer.addSublayer(shapeLayer)
		}
		
		// Setup layers
		configureShapeLayer(trailCircle)
		trailCircle.strokeColor = trailStrokeColor.cgColor
		
		configureShapeLayer(circle)
		circle.strokeColor = strokeColor.cgColor
		
		configureShapeLayer(checkmark)
		checkmark.strokeColor = strokeColor.cgColor
		
		// Setup initial state
		self.setSelected(false, animated: false)
		
		// Add target for handling touch up inside event as a default manner
		self.addTarget(self, action: #selector(AIFlatSwitch.handleTouchUpInside), for: UIControlEvents.touchUpInside)
	}
	
	/**
		Switches between selected and deselected state with touch up inside events. Set animatesOnTouch to false to disable animation on touch.
		Send valueChanged event as a result.
	*/
	@objc fileprivate func handleTouchUpInside() {
		self.setSelected(!self.isSelected, animated: self.animatesOnTouch)
		self.sendActions(for: UIControlEvents.valueChanged)
	}
	
	/**
		Switches between selected and deselected state. Use this method to programmatically change the valeu of selected state.
		- Parameter isSelected: Whether the switch should be selected or not
		- Parameter animated:	Whether the transition should be animated or not
	*/
	open func setSelected(_ isSelected: Bool, animated: Bool) {
		self.isSelectedInternal = isSelected
		
		// Remove all animations before switching to new state
		checkmark.removeAllAnimations()
		circle.removeAllAnimations()
		trailCircle.removeAllAnimations()
		
		// Reset sublayer values
		self.resetLayerValues(self.isSelectedInternal, stateWillBeAnimated: animated)
		
		// Animate to new state
		if animated {
			self.addAnimations(desiredSelectedState: isSelectedInternal)
		}
	}
	
	open override func layoutSublayers(of layer: CALayer) {
		super.layoutSublayers(of: layer)
		
		guard layer == self.layer else {
			return
		}
		
		var offset: CGPoint = CGPoint.zero
		let radius = fmin(self.bounds.width, self.bounds.height) / 2 - (lineWidth / 2)
		offset.x = (self.bounds.width - radius * 2) / 2.0
		offset.y = (self.bounds.height - radius * 2) / 2.0
		
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		// Calculate frame for circle and trail circle
		let circleAndTrailFrame = CGRect(x: offset.x, y: offset.y, width: radius * 2, height: radius * 2)
		
		let circlePath = UIBezierPath(ovalIn: circleAndTrailFrame)
		trailCircle.path = circlePath.cgPath
		
		circle.transform = CATransform3DIdentity
		circle.frame = self.bounds
		circle.path = UIBezierPath(ovalIn: circleAndTrailFrame).cgPath
		// Rotating circle by 212 degrees to be able to manipulate stroke end location.
		circle.transform = CATransform3DMakeRotation(CGFloat(212 * M_PI / 180), 0, 0, 1)
		
		let origin = CGPoint(x: offset.x + radius, y: offset.y + radius)
		
		// Calculate checkmark path
		let checkmarkPath = UIBezierPath()
		
		var checkmarkStartPoint = CGPoint.zero
		// Checkmark will start from circle's stroke end calculated above.
		checkmarkStartPoint.x = origin.x + radius * CGFloat(cos(212 * M_PI / 180))
		checkmarkStartPoint.y = origin.y + radius * CGFloat(sin(212 * M_PI / 180))
		checkmarkPath.move(to: checkmarkStartPoint)
		
		self.checkmarkSplitPoint = CGPoint(x: offset.x + radius * 0.9, y: offset.y + radius * 1.4)
		checkmarkPath.addLine(to: self.checkmarkSplitPoint)
		
		var checkmarkEndPoint = CGPoint.zero
		// Checkmark will end 320 degrees location of the circle layer.
		checkmarkEndPoint.x = origin.x + radius * CGFloat(cos(320 * M_PI / 180))
		checkmarkEndPoint.y = origin.y + radius * CGFloat(sin(320 * M_PI / 180))
		checkmarkPath.addLine(to: checkmarkEndPoint)
		
		checkmark.frame = self.bounds
		checkmark.path = checkmarkPath.cgPath
		
		CATransaction.commit()
	}
	
	/**
		Switches layer values to selected or deselected state without any animation.
		If the there is going to be an animation(stateWillBeAnimated parameter is true), then the layer values are reset to reverse of the desired state value to provide the transition for animation.
		- Parameter desiredSelectedState:	Desired selection state for the reset to handle
		- Parameter stateWillBeAnimated:	If the reset should prepare the layers for animation
	*/
	fileprivate func resetLayerValues(_ desiredSelectedState: Bool, stateWillBeAnimated: Bool) {
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		if (desiredSelectedState && stateWillBeAnimated) || (desiredSelectedState == false && stateWillBeAnimated == false)  {
			// Switch to deselected state
			checkmark.strokeEnd = 0.0
			checkmark.strokeStart = 0.0
			trailCircle.opacity = 0.0
			circle.strokeStart = 0.0
			circle.strokeEnd = 1.0
		} else {
			// Switch to selected state
			checkmark.strokeEnd = finalStrokeEndForCheckmark
			checkmark.strokeStart = finalStrokeStartForCheckmark
			trailCircle.opacity = 1.0
			circle.strokeStart = 0.0
			circle.strokeEnd = 0.0
		}
		
		CATransaction.commit()
	}
	
	/**
		Animates the selected state transition.
		- Parameter desiredSelectedState:	Desired selection state for the animation to handle
	*/
	fileprivate func addAnimations(desiredSelectedState selected: Bool) {
		let circleAnimationDuration = animationDuration * 0.5
		
		let checkmarkEndDuration = animationDuration * 0.8
		let checkmarkStartDuration = checkmarkEndDuration - circleAnimationDuration
		let checkmarkBounceDuration = animationDuration - checkmarkEndDuration
		
		let checkmarkAnimationGroup = CAAnimationGroup()
		checkmarkAnimationGroup.isRemovedOnCompletion = false
		checkmarkAnimationGroup.fillMode = kCAFillModeForwards
		checkmarkAnimationGroup.duration = animationDuration
		checkmarkAnimationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
		
		let checkmarkStrokeEndAnimation = CAKeyframeAnimation(keyPath: "strokeEnd")
		checkmarkStrokeEndAnimation.duration = checkmarkEndDuration + checkmarkBounceDuration
		checkmarkStrokeEndAnimation.isRemovedOnCompletion = false
		checkmarkStrokeEndAnimation.fillMode = kCAFillModeForwards
		checkmarkStrokeEndAnimation.calculationMode = kCAAnimationPaced
		
		if selected {
			checkmarkStrokeEndAnimation.values = [NSNumber(value: 0.0 as Float), NSNumber(value: Float(finalStrokeEndForCheckmark + checkmarkBounceAmount) as Float), NSNumber(value: Float(finalStrokeEndForCheckmark) as Float)]
			checkmarkStrokeEndAnimation.keyTimes = [NSNumber(value: 0.0 as Double), NSNumber(value: checkmarkEndDuration as Double), NSNumber(value: checkmarkEndDuration + checkmarkBounceDuration as Double)]
		} else {
			checkmarkStrokeEndAnimation.values = [NSNumber(value: Float(finalStrokeEndForCheckmark) as Float), NSNumber(value: Float(finalStrokeEndForCheckmark + checkmarkBounceAmount) as Float), NSNumber(value: -0.1 as Float)]
			checkmarkStrokeEndAnimation.keyTimes = [NSNumber(value: 0.0 as Double), NSNumber(value: checkmarkBounceDuration as Double), NSNumber(value: checkmarkEndDuration + checkmarkBounceDuration as Double)]
		}
		
		let checkmarkStrokeStartAnimation = CAKeyframeAnimation(keyPath: "strokeStart")
		checkmarkStrokeStartAnimation.duration = checkmarkStartDuration + checkmarkBounceDuration
		checkmarkStrokeStartAnimation.isRemovedOnCompletion = false
		checkmarkStrokeStartAnimation.fillMode = kCAFillModeForwards
		checkmarkStrokeStartAnimation.calculationMode = kCAAnimationPaced
		
		if selected {
			checkmarkStrokeStartAnimation.values = [NSNumber(value: 0.0 as Float), NSNumber(value: Float(finalStrokeStartForCheckmark + checkmarkBounceAmount) as Float), NSNumber(value: Float(finalStrokeStartForCheckmark) as Float)]
			checkmarkStrokeStartAnimation.keyTimes = [NSNumber(value: 0.0 as Double), NSNumber(value: checkmarkStartDuration as Double), NSNumber(value: checkmarkStartDuration + checkmarkBounceDuration as Double)]
		} else {
			checkmarkStrokeStartAnimation.values = [NSNumber(value: Float(finalStrokeStartForCheckmark) as Float), NSNumber(value: Float(finalStrokeStartForCheckmark + checkmarkBounceAmount) as Float), NSNumber(value: 0.0 as Float)]
			checkmarkStrokeStartAnimation.keyTimes = [NSNumber(value: 0.0 as Double), NSNumber(value: checkmarkBounceDuration as Double), NSNumber(value: checkmarkStartDuration + checkmarkBounceDuration as Double)]
		}
		
		if selected {
			checkmarkStrokeStartAnimation.beginTime = circleAnimationDuration
		}
		
		checkmarkAnimationGroup.animations = [checkmarkStrokeEndAnimation, checkmarkStrokeStartAnimation]
		checkmark.add(checkmarkAnimationGroup, forKey: "checkmarkAnimation")
		
		let circleAnimationGroup = CAAnimationGroup()
		circleAnimationGroup.duration = animationDuration
		circleAnimationGroup.isRemovedOnCompletion = false
		circleAnimationGroup.fillMode = kCAFillModeForwards
		circleAnimationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
		
		let circleStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
		circleStrokeEnd.duration = circleAnimationDuration
		if selected {
			circleStrokeEnd.beginTime = 0.0
			
			circleStrokeEnd.fromValue = NSNumber(value: 1.0 as Float)
			circleStrokeEnd.toValue = NSNumber(value: -0.1 as Float)
		} else {
			circleStrokeEnd.beginTime = animationDuration - circleAnimationDuration
			
			circleStrokeEnd.fromValue = NSNumber(value: 0.0 as Float)
			circleStrokeEnd.toValue = NSNumber(value: 1.0 as Float)
		}
		circleStrokeEnd.isRemovedOnCompletion = false
		circleStrokeEnd.fillMode = kCAFillModeForwards
		
		circleAnimationGroup.animations = [circleStrokeEnd]
		circle.add(circleAnimationGroup, forKey: "circleStrokeEnd")
		
		let trailCircleColor = CABasicAnimation(keyPath: "opacity")
		trailCircleColor.duration = animationDuration
		if selected {
			trailCircleColor.fromValue = NSNumber(value: 0.0 as Float)
			trailCircleColor.toValue = NSNumber(value: 1.0 as Float)
		} else {
			trailCircleColor.fromValue = NSNumber(value: 1.0 as Float)
			trailCircleColor.toValue = NSNumber(value: 0.0 as Float)
		}
		trailCircleColor.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
		
		trailCircleColor.fillMode = kCAFillModeForwards
		trailCircleColor.isRemovedOnCompletion = false
		trailCircle.add(trailCircleColor, forKey: "trailCircleColor")
	}
	
}
