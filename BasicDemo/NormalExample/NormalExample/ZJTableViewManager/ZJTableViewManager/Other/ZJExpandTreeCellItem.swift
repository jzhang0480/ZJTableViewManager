//
//  ZJExpandTreeCell.swift
//  ZJExpandTreeDeme
//
//  Created by Javen on 2019/3/19.
//  Copyright © 2019 Javen. All rights reserved.
//  https://www.jianshu.com/p/49ed18a01f19

import UIKit

open class ZJExpandTreeCellItem: ZJTableViewItem {
    public private(set) var level: Int = 0
    public var isExpand = false
    public var arrSubLevel = [ZJExpandTreeCellItem]()
    /// 展开或者收起下级cell的回调
    public var willExpand: ((ZJExpandTreeCellItem) -> Void)?
    public weak var superLevelItem: ZJExpandTreeCellItem?
    /// 折叠时是否保持下级的树形结构
    public var isKeepStructure = true
    /// 是否自动折叠已经打开的Cell
    public var isAutoClose = false

    public override init() {
        super.init()
        selectionStyle = .none

        setSelectionHandler { [unowned self] (callBackItem: ZJExpandTreeCellItem) in
            if let superLevelItem = self.superLevelItem, superLevelItem.isAutoClose {
                // 寻找同级已经展开的item
                let arrItems = superLevelItem.getAllBelowItems().filter({$0.level == self.level && $0 != self && $0.isExpand})
                for item in arrItems {
                    item.toggleExpand()
                }
            }
            callBackItem.toggleExpand()
        }
    }

    public func addSub(item: ZJExpandTreeCellItem, section: ZJTableViewSection) {
        arrSubLevel.append(item)
        item.superLevelItem = self
        item.level = level + 1
        if ZJExpandTreeCellItem.checkIfFoldedBySupperLevel(self), isExpand {
            section.add(item: item)
        }
    }

    /// 处理展开事件，返回值是当前cell的状态（展开或者收起）
    @discardableResult open func toggleExpand() -> Bool {
        var arrItems: [ZJExpandTreeCellItem]
        if isExpand {
            // 点击之前是打开的，直接通过递归获取item
            arrItems = getAllBelowItems()
            isExpand = !isExpand
        } else {
            // 点击之前是关闭的，需要先改变isExpand属性（不这么做会导致这一个level下一级的cell不显示）
            isExpand = !isExpand
            arrItems = getAllBelowItems()
            if !isKeepStructure {
                var tempItems = [ZJExpandTreeCellItem]()
                for item in arrItems {
                    item.isExpand = false
                    if item.level == level + 1 {
                        tempItems.append(item)
                    }
                }
                arrItems = tempItems
            }
        }
        willExpand?(self)
        if isExpand {
            section.insert(arrItems, afterItem: self, animate: .fade)
        } else {
            section.delete(arrItems, animate: .fade)
        }
        zj_log(isExpand ? "展开" : "收起")

        return isExpand
    }

    /// 获取当前item下面所有的item
    public func getAllBelowItems() -> [ZJExpandTreeCellItem] {
        var arrItems = [ZJExpandTreeCellItem]()
        ZJExpandTreeCellItem.recursionForItem(self, outItems: &arrItems)
        return arrItems
    }

    /// 递归获取一个item下面所有显示的item
    public class func recursionForItem(_ item: ZJExpandTreeCellItem, outItems: inout [ZJExpandTreeCellItem]) {
        for subItem in item.arrSubLevel {
            zj_log(subItem.level)
            if item.isExpand == true {
                outItems.append(subItem)
                if item.arrSubLevel.count != 0 {
                    recursionForItem(subItem, outItems: &outItems)
                }
            }
        }
    }

    // 递归判断一个item是否在某个父节点被折叠
    public class func checkIfFoldedBySupperLevel(_ item: ZJExpandTreeCellItem) -> Bool {
        guard let superItem = item.superLevelItem else {
            return item.isExpand
        }

        if superItem.isExpand {
            return checkIfFoldedBySupperLevel(superItem)
        } else {
            return false
        }
    }
}
