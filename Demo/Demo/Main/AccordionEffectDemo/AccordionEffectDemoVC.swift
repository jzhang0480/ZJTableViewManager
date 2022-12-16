//
//  ViewController.swift
//  ZJAccordionEffectDemo
//
//  Created by Javen on 2019/3/19.
//  Copyright © 2019 Javen. All rights reserved.
//

import UIKit
import ZJTableViewManager

class AccordionEffectDemoVC: UIViewController {
    @IBOutlet var tableView: UITableView!
    var manager: ZJAccordionManager!
    var section = ZJAccordionSection()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "AccordionEffect"
        manager = ZJAccordionManager(tableView: tableView)

        manager.add(section: section)
        defaultExpandItems()
        customExpandItems()
        customExpandButton()
        customExpandButtonAndExpandAction()
        manager.reload()
    }

    /// ************自动处理展开事件的示例*************
    func defaultExpandItems() {
        // level 0
        let item0 = Level0CellItem()
        item0.title = "自动处理展开事件"
        // 当前这一级在收起的时候会忽略后面层级的树形结构。
        // 比如1，2级都是展开的，点击0级收起之后再展开，1，2级都会是收起状态。
        item0.isKeepStructure = false
        // 自动关闭其他展开的cell
        item0.isAutoClose = true
        // 默认是false，我这里需要第1级是展开状态，所以单独设置true
        section.add(item: item0, parentItem: nil, isExpand: true)

        // level 1
        for _ in 0 ..< 3 {
            let item1 = Level1CellItem()
            section.add(item: item1, parentItem: item0)

            // level 2
            for _ in 0 ..< 3 {
                let item2 = Level2CellItem()
                section.add(item: item2, parentItem: item1)

                // level 3
                let text = "The world can be changed by man's endeavor, and that this endeavor can lead to something new and better .No man can sever the bonds that unite him to his society simply by averting his eyes . He must ever be receptive and sensitive to the new ; and have sufficient courage and skill to novel facts and to deal with them ."
                let item3 = Level3CellItem(title: text)
                section.add(item: item3, parentItem: item2)
            }
        }
    }

    /// ************自定义展开操作的示例（如网络请求等）*************
    func customExpandItems() {
        // level 0
        let rootItem = Level0CellItem()
        rootItem.title = "网络请求获取数据自定义展开事件"
        section.add(item: rootItem)

        // 自定义点击事件处理，重写回调就会覆盖掉默认的展开事件
        rootItem.setSelection { [unowned self] (callBackItem: Level0CellItem) in

            // 判断是否已经从网络获得过数据，有的话就直接展开或收起
            // （实际项目根据实际情况来判断，这里只是个例子）
            if callBackItem.childItems.count > 0 {
                // toggleExpand()执行动作方法，展开或收起，方法内部会自动处理
                callBackItem.toggleExpand()
                return
            }

            // 模拟网络请求
            mockHttpRequest(view: callBackItem.cell.contentView) { [unowned self] in
                // 网络请求完成 添加数据
                for _ in 0 ..< 3 {
                    let newItem = Level1CellItem()
                    self.section.add(item: newItem, parentItem: callBackItem)
                }
                callBackItem.toggleExpand()
            }
        }
    }

    func customExpandButton() {
        // level 0
        let rootItem = CustomExpandButtonCellItem()
        rootItem.title = "自定义展开按钮"
        section.add(item: rootItem)

        for _ in 0 ..< 3 {
            let newItem = Level1CellItem()
            section.add(item: newItem, parentItem: rootItem)
        }
    }

    func customExpandButtonAndExpandAction() {
        // level 0
        let rootItem = CustomExpandButtonCellItem()
        rootItem.title = "自定义展开按钮和展开事件"
        section.add(item: rootItem)

        // 自定义点击事件处理，调用这个方法重写回z调就会覆盖掉默认的展开事件
        rootItem.buttonTapCallBack = { [unowned self] callBackItem in

            // 判断是否已经从网络获得过数据，有的话就直接展开或收起（实际项目根据实际情况来判断，这里只是个例子）
            if callBackItem.childItems.count > 0 {
                // toggleExpand()执行动作方法，展开或收起，方法内部会自动处理
                callBackItem.toggleExpand()
                return
            }

            // 模拟网络请求
            mockHttpRequest(view: callBackItem.cell.contentView) { [unowned self] in
                // 网络请求完成 添加数据
                for _ in 0 ..< 3 {
                    let newItem = Level1CellItem()
                    self.section.add(item: newItem, parentItem: callBackItem)
                }
                callBackItem.toggleExpand()
            }
        }
    }
}
