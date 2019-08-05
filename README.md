# AIFlatSwitch

A smooth, nice looking and IBDesignable flat design switch for iOS. Can be used instead of UISwitch.

Inspired by Creativedash's Dribbble post [here](http://dribbble.com/shots/1631598-On-Off)

<p align="center">
<a target="_blank" rel="noopener noreferrer" href="http://dribbble.com/shots/1631598-On-Off">
<img src="https://s3.amazonaws.com/f.cl.ly/items/1p0w3B0E3m2I2k3e0z1Q/onoff.gif" width="200" max-width="80%" alt="Flat switch animation">
</a>
</p>

<p align="center">
<img src="https://img.shields.io/badge/Swift-5.0-orange.svg"/>
<a href="https://cocoapods.org/pods/AIFlatSwitch">
<img src="https://img.shields.io/cocoapods/v/AIFlatSwitch.svg" alt="cocoapods"/>
</a>
</p>
<p align="center">
<img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square"/>
</p>

## Requirements
- iOS 8.0+, tvOS 12.0+
- Xcode 11.0+
- Swift 5

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
flatSwitch.isSelected = true
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
			print(flatSwitch.isSelected)
		}
	}
```

> Animation observer callbacks:

```swift
flatSwitch.selectionAnimationDidStart = { isSelected in
    print("New state: \(isSelected)")
}

flatSwitch.selectionAnimationDidStop = { isSelected in
    print("State when animation stopped: \(isSelected)")
}
```

> Styling the switch:

```swift
flatSwitch.lineWidth = 2.0
flatSwitch.strokeColor = UIColor.blue
flatSwitch.trailStrokeColor = UIColor.red
flatSwitch.backgroundLayerColor = UIColor.red
flatSwitch.animatesOnTouch = false
```
- [x] IBInspectable

## Contribution guidelines

- Make your changes in your branch
- Bump the pod version in AIFlatSwitch.podspec file (e.g. 1.0.1 to 1.0.2)
- Make sure the Example project compiles and works fine in the Simulator
- Find references to your source code changes in README.md and update them (e.g. method names, changed features)
- Create a pull request

## License

AIFlatSwitch is released under the MIT license. See LICENSE for details.

animated check button, checkmark
