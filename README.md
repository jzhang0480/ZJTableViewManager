### 关于ZJTableViewManager
最近开始用Swift写项目，在这之前只看了看Swift相关的文档，突然开始写很不适应，特别是之前一直在用的数据驱动的TableView框架`RETableViewManger`没有Swift版，混编的话也有问题（可能是Swift 4.0不兼容吧）于是就决定自己写一下Swift版的，使用方式基本一模一样。

### 导入
直接拖入ZJTableViewManager文件夹里面的文件，或者用cocoapods
`pod 'ZJTableViewManager', '~> 0.0.9'`

### 关于数据驱动TableView & 使用方式
数据驱动搭建TableView页面，简单来说就是开发者不需要处理TableView的delegate、dataSource，只需要关心数据的处理。数据处理好，页面就按照数据的样子搭建起来了。
举个例子，要实现下面这个界面：
![image](https://github.com/JavenZ/ZJTableViewManager/blob/master/ScreenShot/forms_shot.jpg)

使用TableView初始化ZJTableViewManager，添加一个section，section里面添加cell
```swift
class ZJTableViewController: UIViewController {
    var tableView: UITableView!
    var manager: ZJTableViewManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initialize tableView
        self.tableView = UITableView(frame: self.view.bounds, style: self.tableViewStyle)
        self.view.addSubview(self.tableView);
        //initialize tableViewManager
        self.manager = ZJTableViewManager(tableView: self.tableView)
        
        //add section
        let section = ZJTableViewSection()
        self.manager.add(section: section)
        
        //add cell
        let simpleStringItem = ZJTableViewItem(tableViewCellStyle: .default)
        simpleStringItem.systemCell?.textLabel?.text = "Simple String"
        section.add(item: simpleStringItem)
        
        //Full length text field
        section.add(item: ZJTextFieldItem(title: nil, placeHolder: "Full length text field", text: nil, isFullLength: true, didChanged: nil))
        
        //Text Item
        section.add(item: ZJTextFieldItem(title: "Text Item", placeHolder: "Text", text: nil, didChanged: { (item) in
            if let text = (item as! ZJTextFieldItem).text {
                print(text)
            }
        }))
        
        //Password
        let passwordItem = ZJTextFieldItem(title: "Password", placeHolder: "Password Item", text: nil, didChanged: { (item) in
            if let text = (item as! ZJTextFieldItem).text {
                print(text)
            }
        })
        passwordItem.isSecureTextEntry = true
        section.add(item: passwordItem)
        
        //Switch Item
        section.add(item: ZJSwitchItem(title: "Switch Item", isOn: false, didChanged: { (item) in
            print((item as! ZJSwitchItem).isOn)
        }))
        // Do any additional setup after loading the view.
    }
```
到这里，这个界面就搭建好了，add item的顺序就是界面上cell的展示顺序，不需要写tableview的那些代理。

### 界面操作
**都可以使用系统自带的动画**

代码删除cell：
```
passwordItem.delete(.automatic)
```

侧滑删除
```swift
            let item = ZJTableViewItem(title: "section 1, item " + String(i))
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

刷新section：
```
section.remove(item: simpleStringItem)
section.remove(item: passwordItem)
section.reload(.automatic)
```

sectionHeader 出现、消失的回调
```swift
section.setHeaderWillDisplayHandler({ (currentSection) in
                print("Section" + String(currentSection.index) + " will display!")
            })
            
section.setHeaderDidEndDisplayHandler({ (currentSection) in
                print("Section" + String(currentSection.index) + " did end display!")
            })
```

### 使用效果：
demo 电商项目的评价、打星评分、添加评论图片,

![image](https://github.com/JavenZ/ZJTableViewManager/blob/master/ScreenShot/pictureitem_edit.gif?raw=true)    ![image](https://github.com/JavenZ/ZJTableViewManager/blob/master/ScreenShot/pictrue_item_read.gif?raw=true)

这里主要有3个cell，一个打星的cell，一个评论的cell，一个添加图片的cell。viewController里只有20行代码，耦合性非常低。

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
            //评价cell
            section.add(item: OrderEvaluateItem(title: "评价"))
            let textItem = ZJTextItem(text: nil, placeHolder: "请在此输入您的评价~", didChanged: nil)
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

### 注：
1.tableView可以storyboard、xib、纯代码初始化

2.我自己使用主要是用xib方式搭建的cell，纯代码的cell应该也支持

3.找这个库的人应该也是像我这样用惯了RETableViewManger吧，使用自定义cell的体验应该是差不多的，但是有许多特性还没有支持，也没有RE那么多自带的cell样式，这个只能慢慢补了（我先把我自己项目要用到的特性弄好……）

**最后，我本人也才接触Swift没几天，所以估计这里面会有很多问题，目前只是能满足大部分搭建界面的需要，实现也比较简单，方便使用tableView而已。希望大家多提建议**


