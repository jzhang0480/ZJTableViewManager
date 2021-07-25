//
//  ZJTableViewSection.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 . All rights reserved.
//

import UIKit

public typealias ZJTableViewSectionBlock = (ZJTableViewSection) -> Void

open class ZJTableViewSection: NSObject {
    private weak var _tableViewManager: ZJTableViewManager?
    public var tableViewManager: ZJTableViewManager {
        set {
            _tableViewManager = newValue
        }
        get {
            guard let tableViewManager = _tableViewManager else {
                zj_log("Please add section to manager")
                fatalError()
            }
            return tableViewManager
        }
    }

    public var items = [ZJTableViewItem]()
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

    public func add(item: ZJTableViewItem) {
        item.section = self
        items.append(item)
    }

    public func remove(item: ZJTableViewItem) {
        // If crash at here, item not in this section
        items.remove(at: items.zj_indexOf(item))
    }

    public func removeAllItems() {
        items.removeAll()
    }

    public func replaceItemsFrom(array: [ZJTableViewItem]!) {
        removeAllItems()
        items = items + array
    }

    public func insert(_ item: ZJTableViewItem!, afterItem: ZJTableViewItem, animate: UITableView.RowAnimation = .automatic) {
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

    public func insert(_ items: [ZJTableViewItem], afterItem: ZJTableViewItem, animate: UITableView.RowAnimation = .automatic) {
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

    public func delete(_ itemsToDelete: [ZJTableViewItem], animate: UITableView.RowAnimation = .automatic) {
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
