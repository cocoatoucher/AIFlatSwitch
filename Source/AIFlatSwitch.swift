//
//  AIFlatSwitch.swift
//  AIFlatSwitch
//
//  Created by cocoatoucher on 11/02/15.
//  Copyright (c) 2015 cocoatoucher. All rights reserved.
//

import UIKit

@IBDesignable public class AIFlatSwitch: UIControl {
	
	let finalStrokeEndForCheckmark: CGFloat = 0.85
	let finalStrokeStartForCheckmark: CGFloat = 0.3
	let checkmarkBounceAmount: CGFloat = 0.1
	let animationDuration: CFTimeInterval = 0.3
	
	@IBInspectable public var lineWidth: CGFloat = 2.0 {
		didSet {
			self.circle.lineWidth = lineWidth
			self.checkmark.lineWidth = lineWidth
			self.trailCircle.lineWidth = lineWidth
		}
	}
	
	@IBInspectable public var strokeColor: UIColor = UIColor.blackColor() {
		didSet {
			self.circle.strokeColor = strokeColor.CGColor
			self.checkmark.strokeColor = strokeColor.CGColor
		}
	}
	
	@IBInspectable public var trailStrokeColor: UIColor = UIColor.grayColor() {
		didSet {
			self.trailCircle.strokeColor = trailStrokeColor.CGColor
		}
	}
	
	@IBInspectable public override var selected: Bool {
		get {
			return selected_internal
		}
		set {
			super.selected = newValue
			self.setSelected(newValue, animated: false)
		}
	}
	
	private var trailCircle: CAShapeLayer = CAShapeLayer()
	private var circle: CAShapeLayer = CAShapeLayer()
	private var checkmark: CAShapeLayer = CAShapeLayer()
	
	private var checkmarkMidPoint: CGPoint = CGPointZero
	
	private var selected_internal: Bool = false
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.configure()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.configure()
	}
	
	public override func awakeFromNib() {
		super.awakeFromNib()
		
		self.configure()
	}
	
	public override func layoutSublayersOfLayer(layer: CALayer!) {
		super.layoutSublayersOfLayer(layer)
		
		if layer == self.layer {
			
			var offset: CGPoint = CGPointZero
			let radius = fmin(self.bounds.width, self.bounds.height) / 2
			offset.x = (self.bounds.width - radius * 2) / 2.0
			offset.y = (self.bounds.height - radius * 2) / 2.0
			
			CATransaction.begin()
			CATransaction.setDisableActions(true)
			
			let ovalRect = CGRectMake(offset.x, offset.y, radius * 2, radius * 2)
			
			let circlePath = UIBezierPath(ovalInRect: ovalRect)
			trailCircle.path = circlePath.CGPath
			
			circle.transform = CATransform3DIdentity
			circle.frame = self.bounds
			circle.path = UIBezierPath(ovalInRect: ovalRect).CGPath
			circle.transform = CATransform3DMakeRotation(CGFloat(212 * M_PI / 180), 0, 0, 1)
			
			let origin = CGPointMake(offset.x + radius, offset.y + radius)
			var checkStartPoint = CGPointZero
			checkStartPoint.x = origin.x + radius * CGFloat(cos(212 * M_PI / 180))
			checkStartPoint.y = origin.y + radius * CGFloat(sin(212 * M_PI / 180))
			
			let checkmarkPath = UIBezierPath()
			checkmarkPath.moveToPoint(checkStartPoint)
			
			self.checkmarkMidPoint = CGPointMake(offset.x + radius * 0.9, offset.y + radius * 1.4)
			checkmarkPath.addLineToPoint(self.checkmarkMidPoint)
			
			var checkEndPoint = CGPointZero
			checkEndPoint.x = origin.x + radius * CGFloat(cos(320 * M_PI / 180))
			checkEndPoint.y = origin.y + radius * CGFloat(sin(320 * M_PI / 180))
			
			checkmarkPath.addLineToPoint(checkEndPoint)
			
			checkmark.frame = self.bounds
			checkmark.path = checkmarkPath.CGPath
			
			CATransaction.commit()
		}
	}
	
	private func configure() {
		
		self.backgroundColor = UIColor.clearColor()
		
		configureShapeLayer(trailCircle)
		trailCircle.strokeColor = trailStrokeColor.CGColor
		
		configureShapeLayer(circle)
		circle.strokeColor = strokeColor.CGColor
		
		configureShapeLayer(checkmark)
		checkmark.strokeColor = strokeColor.CGColor
		
		self.setSelected(false, animated: false)
		
		self.addTarget(self, action: "onTouchUpInside:", forControlEvents: UIControlEvents.TouchUpInside)
	}
	
	internal func onTouchUpInside(sender: AnyObject) {
		self.setSelected(!self.selected, animated: true)
		self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
	}
	
	private func configureShapeLayer(shapeLayer: CAShapeLayer) {
		shapeLayer.lineJoin = kCALineJoinRound
		shapeLayer.lineCap = kCALineCapRound
		shapeLayer.lineWidth = self.lineWidth
		shapeLayer.fillColor = UIColor.clearColor().CGColor
		self.layer.addSublayer(shapeLayer)
	}
	
	public func setSelected(isSelected: Bool, animated: Bool) {
		self.selected_internal = isSelected
		
		checkmark.removeAllAnimations()
		circle.removeAllAnimations()
		trailCircle.removeAllAnimations()
		
		self.resetValues(animated: animated)
		
		if animated {
			self.addAnimationsForSelected(selected_internal)
		}
	}
	
	private func resetValues(animated animated: Bool) {
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		if (selected_internal && animated) || (selected_internal == false && animated == false)  {
			checkmark.strokeEnd = 0.0
			checkmark.strokeStart = 0.0
			trailCircle.opacity = 0.0
			circle.strokeStart = 0.0
			circle.strokeEnd = 1.0
		} else {
			checkmark.strokeEnd = finalStrokeEndForCheckmark
			checkmark.strokeStart = finalStrokeStartForCheckmark
			trailCircle.opacity = 1.0
			circle.strokeStart = 0.0
			circle.strokeEnd = 0.0
		}
		
		CATransaction.commit()
	}
	
	private func addAnimationsForSelected(selected: Bool) {
		let circleAnimationDuration = animationDuration * 0.5
		
		let checkmarkEndDuration = animationDuration * 0.8
		let checkmarkStartDuration = checkmarkEndDuration - circleAnimationDuration
		let checkmarkBounceDuration = animationDuration - checkmarkEndDuration
		
		let checkmarkAnimationGroup = CAAnimationGroup()
		checkmarkAnimationGroup.removedOnCompletion = false
		checkmarkAnimationGroup.fillMode = kCAFillModeForwards
		checkmarkAnimationGroup.duration = animationDuration
		checkmarkAnimationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
		
		let checkmarkStrokeEnd = CAKeyframeAnimation(keyPath: "strokeEnd")
		checkmarkStrokeEnd.duration = checkmarkEndDuration + checkmarkBounceDuration
		checkmarkStrokeEnd.removedOnCompletion = false
		checkmarkStrokeEnd.fillMode = kCAFillModeForwards
		checkmarkStrokeEnd.calculationMode = kCAAnimationPaced
		
		if selected {
			checkmarkStrokeEnd.values = NSArray(objects: NSNumber(float: 0.0), NSNumber(float: Float(finalStrokeEndForCheckmark + checkmarkBounceAmount)), NSNumber(float: Float(finalStrokeEndForCheckmark))) as [AnyObject]
			checkmarkStrokeEnd.keyTimes = [NSNumber(double: 0.0), NSNumber(double: checkmarkEndDuration), NSNumber(double: checkmarkEndDuration + checkmarkBounceDuration)]
		} else {
			checkmarkStrokeEnd.values = NSArray(objects: NSNumber(float: Float(finalStrokeEndForCheckmark)), NSNumber(float: Float(finalStrokeEndForCheckmark + checkmarkBounceAmount)), NSNumber(float: -0.1)) as [AnyObject]
			checkmarkStrokeEnd.keyTimes = [NSNumber(double: 0.0), NSNumber(double: checkmarkBounceDuration), NSNumber(double: checkmarkEndDuration + checkmarkBounceDuration)]
		}
		
		let checkmarkStrokeStart = CAKeyframeAnimation(keyPath: "strokeStart")
		checkmarkStrokeStart.duration = checkmarkStartDuration + checkmarkBounceDuration
		checkmarkStrokeStart.removedOnCompletion = false
		checkmarkStrokeStart.fillMode = kCAFillModeForwards
		checkmarkStrokeStart.calculationMode = kCAAnimationPaced
		
		if selected {
			checkmarkStrokeStart.values = NSArray(objects: NSNumber(float: 0.0), NSNumber(float: Float(finalStrokeStartForCheckmark + checkmarkBounceAmount)), NSNumber(float: Float(finalStrokeStartForCheckmark))) as [AnyObject]
			checkmarkStrokeStart.keyTimes = [NSNumber(double: 0.0), NSNumber(double: checkmarkStartDuration), NSNumber(double: checkmarkStartDuration + checkmarkBounceDuration)]
		} else {
			checkmarkStrokeStart.values = NSArray(objects: NSNumber(float: Float(finalStrokeStartForCheckmark)), NSNumber(float: Float(finalStrokeStartForCheckmark + checkmarkBounceAmount)), NSNumber(float: 0.0)) as [AnyObject]
			checkmarkStrokeStart.keyTimes = [NSNumber(double: 0.0), NSNumber(double: checkmarkBounceDuration), NSNumber(double: checkmarkStartDuration + checkmarkBounceDuration)]
		}
		
		if selected {
			checkmarkStrokeStart.beginTime = circleAnimationDuration
		}
		
		checkmarkAnimationGroup.animations = [checkmarkStrokeEnd, checkmarkStrokeStart]
		checkmark.addAnimation(checkmarkAnimationGroup, forKey: "checkmarkAnimation")
		
		let circleAnimationGroup = CAAnimationGroup()
		circleAnimationGroup.duration = animationDuration
		circleAnimationGroup.removedOnCompletion = false
		circleAnimationGroup.fillMode = kCAFillModeForwards
		circleAnimationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
		
		let circleStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
		circleStrokeEnd.duration = circleAnimationDuration
		if selected {
			circleStrokeEnd.beginTime = 0.0
			
			circleStrokeEnd.fromValue = NSNumber(float: 1.0)
			circleStrokeEnd.toValue = NSNumber(float: -0.1)
		} else {
			circleStrokeEnd.beginTime = animationDuration - circleAnimationDuration
			
			circleStrokeEnd.fromValue = NSNumber(float: 0.0)
			circleStrokeEnd.toValue = NSNumber(float: 1.0)
		}
		circleStrokeEnd.removedOnCompletion = false
		circleStrokeEnd.fillMode = kCAFillModeForwards
		
		circleAnimationGroup.animations = [circleStrokeEnd]
		circle.addAnimation(circleAnimationGroup, forKey: "circleStrokeEnd")
		
		let trailCircleColor = CABasicAnimation(keyPath: "opacity")
		trailCircleColor.duration = animationDuration
		if selected {
			trailCircleColor.fromValue = NSNumber(float: 0.0)
			trailCircleColor.toValue = NSNumber(float: 1.0)
		} else {
			trailCircleColor.fromValue = NSNumber(float: 1.0)
			trailCircleColor.toValue = NSNumber(float: 0.0)
		}
		trailCircleColor.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
		
		trailCircleColor.fillMode = kCAFillModeForwards
		trailCircleColor.removedOnCompletion = false
		trailCircle.addAnimation(trailCircleColor, forKey: "trailCircleColor")
	}
	
}
