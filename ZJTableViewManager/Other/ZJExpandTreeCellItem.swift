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
    public var didExpand: ((ZJExpandTreeCellItem) -> Void)?
    public weak var superLevelItem: ZJExpandTreeCellItem?
    /// 折叠时是否保持下级的树形结构
    public var isKeepStructure = true
    /// 是否自动折叠已经打开的Cell
    public var isAutoClose = false

    override public init() {
        super.init()
        selectionStyle = .none

        setSelectionHandler { (callBackItem: ZJExpandTreeCellItem) in
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
        var waitForDeleteItems: [ZJExpandTreeCellItem] = []
        var waitForInsertItems: [ZJExpandTreeCellItem] = []
        if isExpand {
            // 点击之前是打开的，直接通过递归获取item
            waitForDeleteItems = allVisibleItemsUnderCurrentItem()
            isExpand = false
        } else {
            // 点击之前是关闭的，需要先改变isExpand属性（不这么做会导致这一个level下一级的cell不显示）
            isExpand = true
            waitForInsertItems = allVisibleItemsUnderCurrentItem()
            if !isKeepStructure {
                var tempItems = [ZJExpandTreeCellItem]()
                for item in waitForInsertItems {
                    item.isExpand = false
                    if item.level == level + 1 {
                        tempItems.append(item)
                    }
                }
                waitForInsertItems = tempItems
            }
        }
        
        if let superLevelItem = self.superLevelItem, superLevelItem.isAutoClose {
            // 寻找同级已经展开的item
            let allSameLevelVisibleItems = superLevelItem.allVisibleItemsUnderCurrentItem(self).filter({$0 != self})
            allSameLevelVisibleItems.forEach({$0.isExpand = false})
            let otherSameLevelVisibleItems = allSameLevelVisibleItems.filter({$0.level != self.level})
            waitForDeleteItems.append(contentsOf: otherSameLevelVisibleItems)
        }
        
        willExpand?(self)
        
        // 删除需要计算旧的indexPath
        var deleteIndexPaths = [IndexPath]()
        for i in waitForDeleteItems {
            deleteIndexPaths.append(i.indexPath)
        }
        
        for i in waitForDeleteItems {
            section.remove(item: i)
        }
        
        // 插入需要计算新的indexPath
        let newFirstIndex = section.items.zj_indexOf(self) + 1
        section.items.insert(contentsOf: waitForInsertItems, at: newFirstIndex)
        var insertIndexPaths = [IndexPath]()
        for i in 0 ..< waitForInsertItems.count {
            waitForInsertItems[i].section = section
            insertIndexPaths.append(IndexPath(item: newFirstIndex + i, section: indexPath.section))
        }
        
        tableVManager.tableView.beginUpdates()
        if insertIndexPaths.count > 0 {
            tableVManager.tableView.insertRows(at: insertIndexPaths, with: .fade)
        }

        if deleteIndexPaths.count > 0 {
            tableVManager.tableView.deleteRows(at: deleteIndexPaths, with: .fade)
        }
        tableVManager.tableView.endUpdates()
        
        didExpand?(self)
        zj_log(isExpand ? "展开" : "收起")

        return isExpand
    }

    /// 获取当前item下面所有的item
    public func allVisibleItemsUnderCurrentItem(_ exceptionNodeItem: ZJExpandTreeCellItem? = nil) -> [ZJExpandTreeCellItem] {
        var arrItems = [ZJExpandTreeCellItem]()
        ZJExpandTreeCellItem.recursionForItem(self, outItems: &arrItems, exceptionNodeItem)
        return arrItems
    }

    /// 递归获取一个item下面所有显示的item
    public class func recursionForItem(_ item: ZJExpandTreeCellItem, outItems: inout [ZJExpandTreeCellItem], _ exceptionNodeItem: ZJExpandTreeCellItem? = nil) {
        for subItem in item.arrSubLevel {
            if exceptionNodeItem == subItem {
                continue
            }
            var string = "Tree: "
            for _ in 0...subItem.level {
                string.append(contentsOf: "  ")
            }
            zj_log(string + "\(subItem.level)")
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
