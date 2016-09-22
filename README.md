# AIFlatSwitch

A smooth, nice looking and IBDesignable flat design switch for iOS. Can be used instead of UISwitch.

Inspired by Creativedash's Dribbble post [here](http://dribbble.com/shots/1631598-On-Off)

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)

<p><a href="url"><img src="https://s3.amazonaws.com/f.cl.ly/items/1p0w3B0E3m2I2k3e0z1Q/onoff.gif" align="left" height="150" width="200" ></a></p>
<br><br><br><br><br><br><br>

##Requirements
- iOS 8.0+
- Xcode 8.0+ (Use pod version 0.0.4 for Xcode 7)
- Swift 3.0+ (Use pod version 0.0.4 for Swift 2.3)

## Installation

> **Embedded frameworks require a minimum deployment target of iOS 8.**
>
> To use with a project targeting iOS 7, you must include the `AIFlatSwitch.swift` source file directly in your project. 
>

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

CocoaPods 0.36 adds supports for Swift and embedded frameworks. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate AIFlatSwitch into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'AIFlatSwitch', '~> 1.0.1'
```

Then, run the following command:

```bash
$ pod install
```

### Manually
1. Download and drop ```AIFlatSwitch.swift``` in your project.  
2. Congratulations!  

---

## Usage

### Creating the flat switch

- Either programmatically

```swift
var flatSwitch = AIFlatSwitch(frame: CGRectMake(0, 0, 50, 50))
```

- Or in Interface Builder

### Methods

> To change its selected state:

```swift
flatSwitch.selected = true
```
- [x] IBInspectable

> or:

```swift
flatSwitch.setSelected(true, animated: true)
```

> To listen to its state changes:

```swift
@IBAction func handleSwitchValueChange(sender: AnyObject) {
		if let flatSwitch = sender as? AIFlatSwitch {
			println(flatSwitch.selected)
		}
	}
```

> Styling the switch:

```swift
flatSwitch.lineWidth = 2.0
flatSwitch.strokeColor = UIColor.blueColor()
flatSwitch.trailStrokeColor = UIColor.redColor()
flatSwitch.animatesOnTouch = false
```
- [x] IBInspectable

## License

AIFlatSwitch is released under the MIT license. See LICENSE for details.

animated check button, checkmark
