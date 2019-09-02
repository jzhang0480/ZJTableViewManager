<img src="Image/logo.png" width="100%">

####A simple star rating view written in pure swift, lightweight but powerful.

######[🇨🇳中文介绍](http://www.jianshu.com/p/28d5f0bac8fd)

##Screenshots

<img src="Image/1.gif" width="30%">
<img src="Image/2.gif" width="30%">
<img src="Image/3.gif" width="30%">

## Requirements

- iOS 8.0+ 
- Xcode 8
- Swift 3.0

##CocoaPods

CocoaPods is the recommended way to add SwiftyStarRatingView to your project.

Add a pod entry for SwiftyStarRatingView to your Podfile.
 
```
	pod 'SwiftyStarRatingView'
```
Second, install SwiftyStarRatingView into your project:
 
```
	pod install
```

## Manually

1. Download the latest code version .
2. Open your project in Xcode,drag the `SwiftyStarRatingView` folder into your project.  Make sure to select Copy items when asked if you extracted the code archive outside of your project.


## Usage

####Create a simple rating view：

```
	let starRatingView = SwiftyStarRatingView()
	
	starRatingView.frame = CGRect(x: x, y: y, width: width, height: height)
	
	starRatingView.maximumValue = 5 		//default is 5
	starRatingView.minimumValue = 0 		//default is 0
	starRatingView.value = 3        		//default is 0
	
	starRatingView.tintColor = UIColor.yellow
	
	starRatingView.addTarget(self, action: #selector(function), for: .valueChanged)
	
	self.view.addSubview(starRatingView)
```

####Setting this property to control whether to display a half stars:

```
	starRatingView.allowsHalfStars = true 	//default is true
    starRatingView.value = 3.5				//default is 0
```

####Whether accurate display:

```
	starRatingView.accurateHalfStars = true //default is true
```

####Always callback or just stop touch:

```
	starRatingView.continuous = true        //default is true
```

####Use custom image:

```
	starRatingView.halfStarImage = UIImage(named: "half.png")
	starRatingView.emptyStarImage = UIImage(named: "empty.png")
    starRatingView.filledStarImage = UIImage(named: "filled.png")
```

####StoryBoard or XIB:

`SwiftyStarRatingView` also works great with Auto Layout, you can use it in StoryBoard or XIB.

<img src="Image/sx.png">

## Contacts	

####If you wish to contact me, email at: chen.developer@foxmail.com

#####Sina : [@后知后觉乀](http://weibo.com/2538296781)

## License	

SwiftyStarRatingView is released under the [GNU GENERAL PUBLIC LICENSE](LICENSE). See LICENSE for details.
