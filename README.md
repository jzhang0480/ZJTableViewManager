### ZJTableViewManager
[![Platform](https://img.shields.io/badge/platform-iOS-red.svg)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift4.0-yellow.svg?style=flat)](https://en.wikipedia.org/wiki/swift)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](http://mit-license.org)

__Powerful data driven content manager for UITableView.__
`ZJTableViewManager` is a lightweight, pure-Swift library for manage the content of any `UITableView` with ease, both forms and lists.  This project is heavily inspired by the popular [RETableViewManager](https://github.com/romaonthego/RETableViewManager). 

`ZJTableViewManager` is built on top of reusable cells technique and provides APIs for mapping any object class to any custom cell subclass.

The general idea is to allow developers to use their own `UITableView` and `UITableViewController` instances (and even subclasses), providing a layer that synchronizes data with the cell appearance.
It fully implements `UITableViewDelegate` and `UITableViewDataSource` protocols so you don't have to.

### Installation
```
cocoapods
pod 'ZJTableViewManager'
```


### Quick Example

![image](https://github.com/JavenZ/ZJTableViewManager/blob/master/ScreenShot/forms_shot.jpg?raw=true)

Get your `UITableView` up and running in several lines of code:
```swift
        self.manager = ZJTableViewManager(tableView: self.tableView)
        
        //add section
        let section = ZJTableViewSection()
        self.manager.add(section: section)
        
        //Simple String
        section.add(item: ZJTableViewItem(title: "Simple String"))
        
        //Full length text field
        section.add(item: ZJTextFieldItem(title: nil, placeHolder: "Full length text field", text: nil, isFullLength: true, didChanged: nil))
        
        //Text Item
        section.add(item: ZJTextFieldItem(title: "Text Item", placeHolder: "Text", text: nil,  didChanged: nil))
        
        //Password
        let passwordItem = ZJTextFieldItem(title: "Password", placeHolder: "Password Item", text: nil,  didChanged: nil))
        passwordItem.isSecureTextEntry = true
        section.add(item: passwordItem)
        
        //Switch Item
        section.add(item: ZJSwitchItem(title: "Switch Item", isOn: false,  didChanged: nil))

```

### Other

delete cell with animation：
```
passwordItem.delete(.automatic)
```

swipe delete cell:
```swift
item.editingStyle = .delete
item.setDeletionHandler(deletionHandler: {[weak self] (item) in
      self?.deleteConfirm(item: item)
      })
```

reload cell：
```
passwordItem.reload(.automatic)
```

update cell height：
```
item.cellHeight = 200
item.updateHeight()
```

reload section：
```
section.reload(.automatic)
```

sectionHeader call back
```swift
section.setHeaderWillDisplayHandler({ (currentSection) in
                print("Section" + String(currentSection.index) + " will display!")
            })
            
section.setHeaderDidEndDisplayHandler({ (currentSection) in
                print("Section" + String(currentSection.index) + " did end display!")
            })
```

### Other Demo

![image](https://github.com/JavenZ/ZJTableViewManager/blob/master/ScreenShot/pictureitem_edit.gif?raw=true)    ![image](https://github.com/JavenZ/ZJTableViewManager/blob/master/ScreenShot/pictrue_item_read.gif?raw=true)

** This is the entire code for this comment page viewController.
```swift
override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Demo"
        self.manager = ZJTableViewManager(tableView: self.tableView)
        
        //register cell
        self.manager?.register(OrderEvaluateCell.self, OrderEvaluateItem.self)
        self.manager?.register(ZJPictureTableCell.self, ZJPictureTableItem.self)
        
        //add section
        let section = ZJTableViewSection(headerHeight: 10, color: UIColor.init(white: 0.9, alpha: 1))
        self.manager?.add(section: section)
        
        //add cells
        for i in 0...10 {
            //evaluat cell
            section.add(item: OrderEvaluateItem(title: "评价"))
            let textItem = ZJTextItem(text: nil, placeHolder: "请在此输入您的评价~", didChanged: nil)
            textItem.isHideSeparator = true
            section.add(item: textItem)
            
            //picture cell
            if i%2 == 1 {
                //pictures readonly
                let pictureItem = ZJPictureTableItem(maxNumber: 5, column: 4, space: 15, width: self.view.frame.size.width, superVC: self, pictures: [image])
                pictureItem.type = .read
                section.add(item: pictureItem)
            }else{
                //pictures editable
                let pictureItem = ZJPictureTableItem(maxNumber: 5, column: 4, space: 15, width: self.view.frame.size.width, superVC: self)
                pictureItem.type = .edit
                section.add(item: pictureItem)
            }
        }
    }
```




