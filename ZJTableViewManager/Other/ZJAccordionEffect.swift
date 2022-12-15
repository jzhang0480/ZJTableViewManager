//
//  ZJAccordionEffect.swift
//  ZJTableViewManager
//
//  Created by Jie Zhang on 2022/12/3.
//  Copyright © 2022 . All rights reserved.
//

import UIKit

open class ZJAccordionSection: ZJSection {

    public func add(item: ZJAccordionItem, parentItem: ZJAccordionItem?, isExpand: Bool = false) {
        item.isExpand = isExpand
        // 没有指定高度，计算出高度信息（这样可以防止系统自动计算导致的动画异常）
        if item.height == UITableView.automaticDimension {
            item.height = manager.layoutSizeFitting(item).height
        }

        if let parentItem = parentItem {
            parentItem.childItems.append(item)
            item.parentItem = parentItem
            item.level = parentItem.level + 1
            if checkVisible(parentItem), parentItem.isExpand {
                add(item: item as! ZJItemable)
            }
        } else {
            add(item: item as! ZJItemable)
        }
    }

    // 检查item是否被折叠（可见）
    public func checkVisible(_ item: ZJAccordionItem) -> Bool {
        if let parentItem = item.parentItem {
            
            if parentItem.isExpand { // 如果父item状态是展开，检查更上一级是否折叠
                return checkVisible(parentItem)
            } else {
                // 父item isExpand是false，说明当前item被折叠（不可见）
                return false
            }
        } else {
            // 递归查找到最顶级的item中途都没有折叠，说明传入的这个item没有被折叠（可见）
            return true
        }
    }
}

open class ZJAccordionManager: ZJTableViewManager {}

open class ZJAccordionItem: ZJItem {
    public fileprivate(set) var level: Int = 0
    public fileprivate(set) var isExpand = false
    public fileprivate(set) var childItems = [ZJAccordionItem]()
    public weak var parentItem: ZJAccordionItem?
    public var willExpand: ((ZJAccordionItem) -> Void)?
    public var didExpand: ((ZJAccordionItem) -> Void)?
    public var isKeepStructure = true
    public var isAutoClose = false

    override public init() {
        super.init()
        selectionStyle = .none
        height = UITableView.automaticDimension
        selectionHandler = { [weak self] _ in
            self?.toggleExpand()
        }
    }

    @discardableResult
    open func toggleExpand() -> Bool {
        var waitForDeleteItems: [ZJAccordionItem] = []
        var waitForInsertItems: [ZJAccordionItem] = []
        if isExpand {
            waitForDeleteItems = allVisibleChildItems()
            isExpand = false
        } else {
            isExpand = true
            waitForInsertItems = allVisibleChildItems()
            if !isKeepStructure {
                var tempItems = [ZJAccordionItem]()
                for item in waitForInsertItems {
                    item.isExpand = false
                    if item.level == level + 1 {
                        tempItems.append(item)
                    }
                }
                waitForInsertItems = tempItems
            }
        }

        var callbackItems: [ZJAccordionItem] = []
        callbackItems.append(self)
        if let parentItem = parentItem, parentItem.isAutoClose {
            parentItem.allVisibleChildItems(self).forEach { item in
                if item.isExpand {
                    if item.level == self.level {
                        callbackItems.append(item)
                    }
                    item.isExpand = false
                }
                if item.level != self.level {
                    waitForDeleteItems.append(item)
                }
            }
        }

        callbackItems.forEach { $0.willExpand?(self) }

        var deleteIndexPaths = [IndexPath]()
        for i in waitForDeleteItems {
            deleteIndexPaths.append(i.indexPath)
        }

        for i in waitForDeleteItems {
            section.remove(item: i)
        }

        let newFirstIndex = section.firstIndex(of: self)! + 1
        section.insert(contentsOf: waitForInsertItems, at: newFirstIndex)
        var insertIndexPaths = [IndexPath]()
        for i in 0 ..< waitForInsertItems.count {
            waitForInsertItems[i].section = section
            insertIndexPaths.append(IndexPath(item: newFirstIndex + i, section: indexPath.section))
        }
        manager.tableView.beginUpdates()
        manager.tableView.deleteRows(at: deleteIndexPaths, with: .fade)
        manager.tableView.insertRows(at: insertIndexPaths, with: .fade)
        manager.tableView.endUpdates()
        callbackItems.forEach { $0.didExpand?(self) }

        return isExpand
    }

    public func allVisibleChildItems(_ exceptionNodeItem: ZJAccordionItem? = nil) -> [ZJAccordionItem] {
        var items = [ZJAccordionItem]()
        allVisibleChildItems(self, outItems: &items, exceptionNodeItem)
        return items
    }

    fileprivate func allVisibleChildItems(_ parentItem: ZJAccordionItem, outItems: inout [ZJAccordionItem], _ exceptionNodeItem: ZJAccordionItem? = nil) {
        for childItem in parentItem.childItems {
            if exceptionNodeItem == childItem {
                continue
            }
            if parentItem.isExpand == true {
                outItems.append(childItem)
                if parentItem.childItems.count != 0 {
                    allVisibleChildItems(childItem, outItems: &outItems)
                }
            }
        }
    }
}
