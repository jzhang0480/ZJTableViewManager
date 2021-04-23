
[English introduction](https://github.com/JavenZ/ZJTableViewManager/blob/master/README_EN.md)


### 关于ZJTableViewManager
强大的数据驱动的TableView，构建复杂TableView从未如此轻松。

### 使用
直接拖入ZJTableViewManager文件夹里面的文件，或者用cocoapods
`pod 'ZJTableViewManager', '~> 1.0.7'`

### 适配
| Version        | Swift     | Xcode              |
| -------------- | --------- | ------------------ |
| 0.2.7          | 4.0 / 4.2 | Xcode10 or later   |
| 1.0.3 or later | 4.0 ~ 5.2 | Xcode10.2 or later |


### 简介
[ZJTableViewManager](https://github.com/JavenZ/ZJTableViewManager) 基于数据驱动页面的理念，接管了`UITableView`的`delegate`和`dataSource`的逻辑，开发者只需要关心数据的处理，避免了冗长的判断，让代码更加易于维护。


比如一个页面里面是UITableView，有5种不同的Cell。按照传统的写法，`tableView(_:cellForRowAt:)`代理方法里会是这样：
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
同时下面两个方法里面也很可能需要写上这一串判断条件。显而易见的缺点：代码冗长
```swift
tableView(_:, heightForRowAt:)
tableView(_:, didSelectRowAt:)
```

其次，实际项目中，很多人直接用`IndexPath`作为判断条件，大量`if else`，且当需要对`Cell`显示顺序做调整时，基于`IndexPath`的判断就会出问题，改起来特别容易出现Bug。

当然有经验的程序员会抽象出一个`type`，通过`type`来判断`Cell`类型，避免`IndexPath`的缺陷。这其实已经算是一种数据驱动的思想了，相比用`IndexPath`判断，更加不容易出问题。但是这还不够，这些方法里面依然会有很多`if else`，影响观感也影响逻辑理解。

**所以[ZJTableViewManager](https://github.com/JavenZ/ZJTableViewManager) 在以上的基础上进一步做了封装，效果如下：**

![](https://upload-images.jianshu.io/upload_images/1653855-235590ab7042ec24.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**就如示例代码所示，不需要处理TableView的delegate和dataSource，不需要那些`if else`，Item控制Cell处理Cell的事件，我们只要专心用代码描述这个TableView长什么样子，它就会按照我们描述的样子搭建出来。**

### 使用方式
#### 1.系统默认Cell
创建系统默认的cell，使用ZJTableViewItem类，创建之后加入section即可
```swift
let item = ZJTableViewItem(title: "测试cell 1")
section.add(item: item)
```
根据需要可以修改样式为`subtitle`
```swift
item.style = .subtitle
item.detailLabelText = "detail label text"
```
运行结果：
![](https://upload-images.jianshu.io/upload_images/1653855-d5dd7f7890aae7e4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**总结一下系统默认Cell的使用步骤：**

1. 页面上创建一个TableView（StoryBoard拖或者纯代码创建都可以）
2. 通过这个TableView初始化一个manager
3. 创建一个Section，加入到manager里
4. 创建Cell对应的Item，赋值之后加入到section里
5. `manager.reload()`

具体不展开说了，系统cell就那几个样式，平时也很少用到，自己尝试吧。
#### 2.自定义Cell
自定义Cell才是我们实际项目中用到最多的，所以这一块需要详细说一下。
我们来尝试自定义这样一个Cell

![](https://upload-images.jianshu.io/upload_images/1653855-127f15ffb418928d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

左边是一个UILabel，右边一个UISwitch，功能是在UISwitch开关时会发出回调，在VC中处理。

首先，新建一个ZJSwitchCell类，继承自UITableViewCell，勾选上Also create XIB file(当然不用XIB，纯代码布局也可以)

![](https://upload-images.jianshu.io/upload_images/1653855-b483247676b353fa.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在xib文件里面拖上控件，并且把控件和UISwitch的value change事件拖线到Cell文件里面:

![](https://upload-images.jianshu.io/upload_images/1653855-dd3722b4e90e93a4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![](https://upload-images.jianshu.io/upload_images/1653855-0319d60626b755c5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


**下面是重点：**
在ZJSwitchCell.swift文件里面写一个ZJSwitchCellItem类，继承自ZJTableViewItem，有三个属性，标题title，开关状态isOn，回调闭包didChanged。
![](https://upload-images.jianshu.io/upload_images/1653855-987d09829c0c8c46.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

让ZJSwitchCell遵循ZJCellProtocol协议，如图所示，Xcode会弹出提示，点击fix，会自动加上需要的方法和类型

![](https://upload-images.jianshu.io/upload_images/1653855-7a180aa4b0738837.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

ZJCelltemClass这里填写上前面写好的ZJSwitchCellItem类名

![](https://upload-images.jianshu.io/upload_images/1653855-77c0c7dddde5d25b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

然后Xcode还会有个错误提示，继续点fix，就好了。

![](https://upload-images.jianshu.io/upload_images/1653855-d8cbf7d997086d67.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
**可能有时候Xcode自动fix补全的代码有问题，比如说`typealias ZJCelltemClass = `出现两遍或者根本没有fix按钮，不要慌，cmd+b编译一下，再试试就好了**

**然后在`cellWillAppear()`方法里面写上赋值操作，它等价于`tableView(_:, cellForRowAt:)`方法。再到`valueChanged(:)`方法里面，记录UISwitch的状态，并把当前这个item通过回调传出去。Cell部分的自定义就完成了。**

![](https://upload-images.jianshu.io/upload_images/1653855-0cb0f5ae02200802.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

最后，在VC里面使用，使用之前需要`manager.register(ZJSwitchCell.self, ZJSwitchItem.self)`注册一下，这和之前使用系统默认的Cell有区别，自定义的Cell都需要注册一下才可以使用。
```swift
class FormViewController: UIViewController {
    var tableView: UITableView!
    var manager: ZJTableViewManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        manager = ZJTableViewManager(tableView: tableView)
        manager.register(ZJSwitchCell.self, ZJSwitchItem.self)

        let section = ZJTableViewSection()
        manager.add(section: section)
        
        // Switch Item
        section.add(item: ZJSwitchItem(title: "Switch Item", isOn: false, didChanged: { item in
            zj_log(item.isOn)
        }))

        manager.reload()
    }
}
```
**总结一下自定义Cell的步骤：**

1. 新建Cell（XIB或者纯代码都可以）
2. 创建Cell对应的Item，通过Item给Cell传值（**实际项目中一般是用Item持有Model，在`cellWillAppear()`中通过item.model取值并赋值到控件里面**）
3. 在VC中给把Cell向TableViewManager注册。
   
其余使用方式参考上面系统默认Cell的使用。

#### 3.Cell固定高度及动态计算高度处理
前面示例的两种Cell高度都是系统默认的44，我们实际项目中需要不同高度的Cell，怎么处理呢？

**固定高度：**
聪明的同学可能已经发现了，Item控制了Cell的所有表现，所以肯定是通过Item来控制的。Item中有个cellHeight属性，只要给它赋值，就能够控制Cell的高度。
我们可以重写Item对象的init()方法，在里面给一个固定的高度
 ```swift
override init() {
    super.init()
    cellHeight = 100
}
```
或者在VC里面初始化Item之后，再给cellHeight赋值，都是可以的。

**动态高度：**
动态高度的前提是使用AutoLayout布局，约束没有缺失，然后在Item赋值好了之后，调用一下autoHeight(:)方法，高度就算好了。
```swift
let item = AutomaticHeightCellItem()
item.feed = feed
//计算高度
item.autoHeight(manager)
//把cell加入进section
section.add(item: item)
```
具体可以看下面的文章，里面说的更详细，这里不展开说了。
[Swift UITableViewCell高性能动态计算高度](https://www.jianshu.com/p/34c495942ed4)
#### 4.TableView相关事件（如点击事件）
设置点击事件回调：
```swift
item.setSelectionHandler { (callBackItem: LevelCellItem) in
    //Do some thing
}
```
其他事件同理，包括section的一些事件（比如section即将出现之类的回调），具体看Demo。
#### 5.Scroll事件的代理
我们在使用TableView的同时，有时还需要处理Scroll事件，比如说判断滚动已经停止，或者监听滚动事件等，可以通过设置`manager.scrollDelegate = self`并遵循`ZJTableViewScrollDelegate `的方式，获取所有滚动事件的回调，使用方式和`UIScrollViewDelegate`一样。


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
        
    }
```

### 注：
TableView可以storyboard、xib、纯代码初始化，cell可以xib或者纯代码构建



