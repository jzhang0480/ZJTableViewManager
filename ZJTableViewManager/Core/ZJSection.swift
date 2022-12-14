//
//  ZJSection.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 . All rights reserved.
//

import UIKit

public typealias ZJTableViewSectionBlock = (ZJSection) -> Void

open class ZJSection: NSObject {
    public var tableViewManager: ZJTableViewManager!

    public private(set) var items = [ZJItem]()
    public var headerHeight: CGFloat!
    public var footerHeight: CGFloat!
    public var headerView: UIView?
    public var footerView: UIView?
    public var headerTitle: String?
    public var footerTitle: String?
    var headerWillDisplayHandler: ZJTableViewSectionBlock?
    public func setHeaderWillDisplayHandler(_ block: ZJTableViewSectionBlock?) {
        headerWillDisplayHandler = block
    }

    var headerDidEndDisplayHandler: ZJTableViewSectionBlock?
    public func setHeaderDidEndDisplayHandler(_ block: ZJTableViewSectionBlock?) {
        headerDidEndDisplayHandler = block
    }

    public var index: Int {
        return tableViewManager.sections.zj_indexOf(self)
    }

    override public init() {
        super.init()
        items = []
        headerHeight = CGFloat.leastNormalMagnitude
        footerHeight = CGFloat.leastNormalMagnitude
    }

    public convenience init(headerHeight: CGFloat!, color: UIColor) {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerHeight))
        headerView.backgroundColor = color
        self.init(headerView: headerView, footerView: nil)
    }

    public convenience init(headerTitle: String?, footerTitle: String?) {
        self.init()
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
    }

    public convenience init(headerTitle: String?) {
        self.init(headerTitle: headerTitle, footerTitle: nil)
    }

    public convenience init(footerTitle: String?) {
        self.init(headerTitle: nil, footerTitle: footerTitle)
    }

    public convenience init(headerView: UIView!) {
        self.init(headerView: headerView, footerView: nil)
    }

    public convenience init(footerView: UIView?) {
        self.init(headerView: nil, footerView: footerView)
    }

    public convenience init(headerView: UIView?, footerView: UIView?) {
        self.init()
        if let header = headerView {
            self.headerView = header
            headerHeight = header.frame.size.height
        }

        if let footer = footerView {
            self.footerView = footer
            footerHeight = footer.frame.size.height
        }
    }

    public func add(item: ZJItemable) {
        item.section = self
        items.append(item)
        item.tableVManager.register(type(of: item))
    }

    public func remove(item: ZJItem) {
        // If crash at here, item not in this section
        items.remove(at: items.zj_indexOf(item))
    }

    public func removeAllItems() {
        items.removeAll()
    }

    public func remove(at i: Int) {
        items.remove(at: i)
    }

    public func insert<C: ZJItem>(contentsOf newElements: [C], at i: Int) {
        let noDuplicateItems = newElements.enumerated().filter { (index, value) -> Bool in
            newElements.firstIndex(of: value) == index
        }.map {
            type(of: $0.element) as! ZJItemable.Type
        }

        tableViewManager.register(noDuplicateItems)
        items.insert(contentsOf: newElements, at: i)
    }

    public func replaceItemsFrom(items: [ZJItem]!) {
        removeAllItems()

        let noDuplicateItems = items.enumerated().filter { (index, value) -> Bool in
            items.firstIndex(of: value) == index
        }.map {
            type(of: $0.element) as! ZJItemable.Type
        }

        tableViewManager.register(noDuplicateItems)

        self.items = items
    }

    public func insert(_ item: ZJItem!, afterItem: ZJItem, animate: UITableView.RowAnimation = .automatic) {
        if !items.contains(where: { $0 == afterItem }) {
            zj_log("can't insert because afterItem did not in sections")
            return
        }

        tableViewManager.tableView.beginUpdates()
        item.section = self
        items.insert(item, at: items.zj_indexOf(afterItem) + 1)
        tableViewManager.tableView.insertRows(at: [item.indexPath], with: animate)
        tableViewManager.tableView.endUpdates()
    }

    public func insert(_ items: [ZJItem], afterItem: ZJItem, animate: UITableView.RowAnimation = .automatic) {
        if !self.items.contains(where: { $0 == afterItem }) {
            zj_log("can't insert because afterItem did not in sections")
            return
        }

        tableViewManager.tableView.beginUpdates()
        let newFirstIndex = self.items.zj_indexOf(afterItem) + 1
        self.items.insert(contentsOf: items, at: newFirstIndex)
        var arrNewIndexPath = [IndexPath]()
        for i in 0 ..< items.count {
            items[i].section = self
            arrNewIndexPath.append(IndexPath(item: newFirstIndex + i, section: afterItem.indexPath.section))
        }
        tableViewManager.tableView.insertRows(at: arrNewIndexPath, with: animate)
        tableViewManager.tableView.endUpdates()
    }

    public func delete(_ itemsToDelete: [ZJItem], animate: UITableView.RowAnimation = .automatic) {
        guard itemsToDelete.count > 0 else { return }
        tableViewManager.tableView.beginUpdates()
        var arrNewIndexPath = [IndexPath]()
        for i in itemsToDelete {
            arrNewIndexPath.append(i.indexPath)
        }
        for i in itemsToDelete {
            remove(item: i)
        }
        tableViewManager.tableView.deleteRows(at: arrNewIndexPath, with: animate)
        tableViewManager.tableView.endUpdates()
    }

    public func reload(_ animation: UITableView.RowAnimation) {
        // If crash at here, section did not in manager！
        let index = tableViewManager.sections.zj_indexOf(self)
        tableViewManager.tableView.reloadSections(IndexSet(integer: index), with: animation)
    }
}
