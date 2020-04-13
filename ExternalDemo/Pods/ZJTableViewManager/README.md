
[English introduction](https://github.com/JavenZ/ZJTableViewManager/blob/master/README_EN.md)
### 关于ZJTableViewManager
强大的数据驱动的TableView，构建复杂TableView从未如此轻松。

### Swift版本适配
Swift 4.0/4.2

### 特性
#### 1、数据驱动，不用写代理方法

添加一个cell，只需要两行代码
```swift
    section.add(item: ZJTableViewItem(title: "Simple String"))
    manager.reload()//或者section.reload(.automatic)
```

#### 2、高度封装，把代理方法操作转化为对cell绑定的item的操作


```swift
删除一个cell并且带动画：
passwordItem.delete(.automatic)
```

```swift
侧滑删除cell
item.editingStyle = .delete
item.setDeletionHandler(deletionHandler: {[weak self] (item) in
      self?.deleteConfirm(item: item)
      })
```

```swift
修改单个cell的高度
item.cellHeight = 200
//这个方法只更新cell高度，有动画，不会cell里的cellWillAppear不会被调用
item.updateHeight()
```
>和系统方法对比，原生方法需要在代理方法里做处理，并且要处理好数据源，容易出现问题。而使用本框架只需要对item做操作即可，数据源和代理方法被框架内部接管，保证效果的实现。

#### 3、自动计算高度：

ZJTableViewManager提供了提前计算cell高度并缓存的api，**一行代码**自动计算高度。
```swift
item.autoHeight(manager)
```
![image](https://github.com/JavenZ/ZJTableViewManager/blob/master/ScreenShot/auto_height.jpg?raw=true)

>高度计算使用系统`estimatedRowHeight`、`UITableViewAutomaticDimension`内部实现一样的方法，计算和预期没有误差

### 使用
以这个Forms页面为例（TableView是用Storyboard拖的）

![image](https://github.com/JavenZ/ZJTableViewManager/blob/master/ScreenShot/forms_shot.jpg?raw=true)

1、使用TableView初始化ZJTableViewManager，并添加一个section
```swift
        self.manager = ZJTableViewManager(tableView: self.tableView)
        
        //add section
        let section = ZJTableViewSection()
        self.manager.add(section: section)
```
2、section里面添加cell
```swift        
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

        //reload
        manager.reload()

```
>到这里，这个界面就搭建好了，add item的顺序就是界面上cell的展示顺序。didChanged是界面上text变化或者按钮触发的回调，实时获取相关数据。

### 关于数据驱动
以上面例子中的Forms页面为例，如果不使用本框架，那`tableView(_:cellForRowAt:)`代理方法里会是这样：
```swift
public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if condition1 {
            return SimpleStringCell
        }else if condition2 {
            return FullLengthTextFieldCell
        }else if condition3 {
            return TextCell
        }else if condition4 {
            return PasswordCell
        }else if condition5 {
            return SwitchCell
        }else {
            return DefaultCell
        }

}
```
如果cell的高度有差异，那`tableView(_:heightForRowAt:)`里面也需要判断，使界面逻辑处理复杂化。（与之相比，使用本框架的那段代码是不是显得特别清爽？）

数据驱动搭建TableView页面，就是为了处理这个情况而诞生的。

开发者不需要处理TableView的delegate、dataSource，只需要关心数据的处理。数据处理好，页面就按照数据的样子搭建起来。

同时对TableView界面的动态改变只需要直接对cell对应的item做操作，数据的处理和TableView的显示效果关联，逻辑处理更加集中，代码更加简洁，更加容易实现复杂的TableView界面，同时代码也更加容易理解。（比如上面Forms页面，看着代码，脑子里就已经可以想象到页面的样子了）

### 界面操作
**都可以使用系统自带的动画**

代码删除cell：
```
passwordItem.delete(.automatic)
```

侧滑删除
```swift
item.editingStyle = .delete
item.setDeletionHandler(deletionHandler: {[weak self] (item) in
      self?.deleteConfirm(item: item)
      })
```

刷新cell：
```
passwordItem.reload(.automatic)
```

更新cell的高度：
```
item.cellHeight = 200
//这个方法只更新cell高度，自带动画，不会reload这个cell
item.updateHeight()
```
批量在某个section里面插入 cell：
```swift
section.insert(arrItems, afterItem: item, animate: .fade)
```
批量删除cell：
```swift
section.delete(arrItems, animate: .fade)
```


刷新section：
```
section.remove(item: simpleStringItem)
section.remove(item: passwordItem)
section.reload(.automatic)
```

sectionHeader 在屏幕上出现、消失的回调
```swift
section.setHeaderWillDisplayHandler({ (currentSection) in
                print("Section" + String(currentSection.index) + " will display!")
            })
            
section.setHeaderDidEndDisplayHandler({ (currentSection) in
                print("Section" + String(currentSection.index) + " did end display!")
            })
```



### Demo：
电商项目的评价、打星评分、添加评论图片,

![image](https://github.com/JavenZ/ZJTableViewManager/blob/master/ScreenShot/pictureitem_edit.gif?raw=true)    ![image](https://github.com/JavenZ/ZJTableViewManager/blob/master/ScreenShot/pictrue_item_read.gif?raw=true)

这里主要有3个cell，一个打星的cell，一个评论的cell，一个添加图片的cell。viewController里只有20行代码，耦合性低。

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
          i  //评价cell
            section.add(item: OrderEvaluateItem(title: "评价"))
            let textItem = ZJTextItem(text: nil, placeHolder: "请在此输入您的评价~", ddChanged: nil)
            textItem.isHideSeparator = true
            section.add(item: textItem)
            
            //图片cell
            if i%2 == 1 {
                //只展示图片
                let pictureItem = ZJPictureTableItem(maxNumber: 5, column: 4, space: 15, width: self.view.frame.size.width, superVC: self, pictures: [image])
                pictureItem.type = .read
                section.add(item: pictureItem)
            }else{
                //添加图片
                let pictureItem = ZJPictureTableItem(maxNumber: 5, column: 4, space: 15, width: self.view.frame.size.width, superVC: self)
                pictureItem.type = .edit
                section.add(item: pictureItem)
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
```

### 使用
直接拖入ZJTableViewManager文件夹里面的文件，或者用cocoapods
`pod 'ZJTableViewManager'`

### 注：
TableView可以storyboard、xib、纯代码初始化，cell可以xib或者纯代码构建



