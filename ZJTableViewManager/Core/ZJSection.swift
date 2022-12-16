//
//  ZJSection.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 . All rights reserved.
//

import UIKit

public typealias ZJTableViewSectionBlock = (ZJSection) -> Void

open class ZJSection {
    public var manager: ZJTableViewManager!

    public private(set) var items: [ZJItem] = .init()
    public var headerTitle: String?
    public var footerTitle: String?
    public var headerView: UIView?
    public var footerView: UIView?
    public var headerHeight: CGFloat = UITableView.automaticDimension
    public var footerHeight: CGFloat = UITableView.automaticDimension
    var headerWillDisplayHandler: ZJTableViewSectionBlock?
    public func setHeaderWillDisplayHandler(_ block: ZJTableViewSectionBlock?) {
        headerWillDisplayHandler = block
    }

    var headerDidEndDisplayHandler: ZJTableViewSectionBlock?
    public func setHeaderDidEndDisplayHandler(_ block: ZJTableViewSectionBlock?) {
        headerDidEndDisplayHandler = block
    }

    public var index: Int {
        return manager.sections.unwrappedIndex(self)
    }

    subscript(index: Int) -> ZJItemable {
        get {
            items[index] as! ZJItemable
        }
        set(newValue) {
            items[index] = newValue
        }
    }

    public func firstIndex(of element: ZJItem) -> Int? {
        return items.firstIndex(of: element)
    }

    public init(headerTitle: String? = nil, footerTitle: String? = nil, headerView: UIView? = nil, footerView: UIView? = nil) {
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.headerView = headerView
        self.footerView = footerView
        headerHeight = headerView?.frame.size.height ?? UITableView.automaticDimension
        footerHeight = footerView?.frame.size.height ?? UITableView.automaticDimension
    }

    public convenience init(headerHeight: CGFloat!, color: UIColor) {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerHeight))
        headerView.backgroundColor = color
        self.init(headerView: headerView)
    }

    public func add(item: ZJItemable) {
        item.section = self
        items.append(item)
        item.manager.register(type(of: item))
    }

    public func remove(item: ZJItem) {
        // If crash at here, item not in this section
        items.remove(at: items.unwrappedIndex(item))
    }

    public func removeAllItems() {
        items.removeAll()
    }

    public func remove(at i: Int) {
        items.remove(at: i)
    }

    public func insert<C: ZJItem>(contentsOf newElements: [C], at i: Int) {
        manager.register(newElements)
        items.insert(contentsOf: newElements, at: i)
    }

    public func replaceItemsFrom(items: [ZJItem]!) {
        removeAllItems()
        manager.register(items)
        self.items = items
    }

    public func insert(_ item: ZJItem!, afterItem: ZJItem, animate: UITableView.RowAnimation = .automatic) {
        if !items.contains(where: { $0 == afterItem }) {
            zj_log("can't insert because afterItem did not in sections")
            return
        }

        manager.tableView.beginUpdates()
        item.section = self
        items.insert(item, at: items.unwrappedIndex(afterItem) + 1)
        manager.tableView.insertRows(at: [item.indexPath], with: animate)
        manager.tableView.endUpdates()
    }

    public func insert(_ items: [ZJItem], afterItem: ZJItem, animate: UITableView.RowAnimation = .automatic) {
        if !self.items.contains(where: { $0 == afterItem }) {
            zj_log("can't insert because afterItem did not in sections")
            return
        }

        manager.tableView.beginUpdates()
        let newFirstIndex = self.items.unwrappedIndex(afterItem) + 1
        self.items.insert(contentsOf: items, at: newFirstIndex)
        var arrNewIndexPath = [IndexPath]()
        for i in 0 ..< items.count {
            items[i].section = self
            arrNewIndexPath.append(IndexPath(item: newFirstIndex + i, section: afterItem.indexPath.section))
        }
        manager.tableView.insertRows(at: arrNewIndexPath, with: animate)
        manager.tableView.endUpdates()
    }

    public func delete(_ itemsToDelete: [ZJItem], animate: UITableView.RowAnimation = .automatic) {
        guard itemsToDelete.count > 0 else { return }
        manager.tableView.beginUpdates()
        var arrNewIndexPath = [IndexPath]()
        for i in itemsToDelete {
            arrNewIndexPath.append(i.indexPath)
        }
        for i in itemsToDelete {
            remove(item: i)
        }
        manager.tableView.deleteRows(at: arrNewIndexPath, with: animate)
        manager.tableView.endUpdates()
    }

    public func reload(_ animation: UITableView.RowAnimation) {
        // If crash at here, section did not in manager！
        let index = manager.sections.unwrappedIndex(self)
        manager.tableView.reloadSections(IndexSet(integer: index), with: animation)
    }
}

extension ZJSection: Equatable {
    public static func == (lhs: ZJSection, rhs: ZJSection) -> Bool {
        return lhs === rhs
    }
}
