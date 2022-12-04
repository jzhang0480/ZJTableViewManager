//
//  ZJAccordionEffect.swift
//  ZJTableViewManager
//
//  Created by Jie Zhang on 2022/12/3.
//  Copyright © 2022 . All rights reserved.
//

import UIKit

open class ZJTableViewAccordionSection: ZJTableViewSection {

    public func add(item: ZJTableViewAccordionItem, parentItem: ZJTableViewAccordionItem?, isExpand: Bool = false) {
        item.isExpand = isExpand
        if item.cellHeight == UITableView.automaticDimension {
            item.autoHeight(tableViewManager)
        }

        if let parentItem = parentItem {
            parentItem.childItems.append(item)
            item.parentItem = parentItem
            item.level = parentItem.level + 1
            if checkVisible(parentItem), parentItem.isExpand {
                add(item: item)
            }
        } else {
            add(item: item)
        }
    }

    public func checkVisible(_ item: ZJTableViewAccordionItem) -> Bool {
        if let parentItem = item.parentItem {
            if parentItem.isExpand {
                return checkVisible(parentItem)
            } else {
                return false
            }
        } else {
            return true
        }
    }
}

open class ZJTableViewAccordionManager: ZJTableViewManager {}

open class ZJTableViewAccordionItem: ZJTableViewItem {
    public fileprivate(set) var level: Int = 0
    public fileprivate(set) var isExpand = false
    public fileprivate(set) var childItems = [ZJTableViewAccordionItem]()
    public weak var parentItem: ZJTableViewAccordionItem?
    public var willExpand: ((ZJTableViewAccordionItem) -> Void)?
    public var didExpand: ((ZJTableViewAccordionItem) -> Void)?
    public var isKeepStructure = true
    public var isAutoClose = false

    override public init() {
        super.init()
        selectionStyle = .none
        cellHeight = UITableView.automaticDimension
        selectionHandler = { [weak self] _ in
            self?.toggleExpand()
        }
    }

    @discardableResult
    open func toggleExpand() -> Bool {
        var waitForDeleteItems: [ZJTableViewAccordionItem] = []
        var waitForInsertItems: [ZJTableViewAccordionItem] = []
        if isExpand {
            waitForDeleteItems = allVisibleChildItems()
            isExpand = false
        } else {
            isExpand = true
            waitForInsertItems = allVisibleChildItems()
            if !isKeepStructure {
                var tempItems = [ZJTableViewAccordionItem]()
                for item in waitForInsertItems {
                    item.isExpand = false
                    if item.level == level + 1 {
                        tempItems.append(item)
                    }
                }
                waitForInsertItems = tempItems
            }
        }

        var callbackItems: [ZJTableViewAccordionItem] = []
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

        let newFirstIndex = section.items.zj_indexOf(self) + 1
        section.items.insert(contentsOf: waitForInsertItems, at: newFirstIndex)
        var insertIndexPaths = [IndexPath]()
        for i in 0 ..< waitForInsertItems.count {
            waitForInsertItems[i].section = section
            insertIndexPaths.append(IndexPath(item: newFirstIndex + i, section: indexPath.section))
        }
        tableVManager.tableView.beginUpdates()
        tableVManager.tableView.deleteRows(at: deleteIndexPaths, with: .fade)
        tableVManager.tableView.insertRows(at: insertIndexPaths, with: .fade)
        tableVManager.tableView.endUpdates()
        callbackItems.forEach { $0.didExpand?(self) }

        return isExpand
    }

    public func allVisibleChildItems(_ exceptionNodeItem: ZJTableViewAccordionItem? = nil) -> [ZJTableViewAccordionItem] {
        var items = [ZJTableViewAccordionItem]()
        allVisibleChildItems(self, outItems: &items, exceptionNodeItem)
        return items
    }

    fileprivate func allVisibleChildItems(_ parentItem: ZJTableViewAccordionItem, outItems: inout [ZJTableViewAccordionItem], _ exceptionNodeItem: ZJTableViewAccordionItem? = nil) {
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
