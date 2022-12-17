//
//  ZJSection.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 . All rights reserved.
//

import UIKit

public protocol ZJSectionable: ZJBaseSection {
    func setHeaderWillDisplayHandler(_ handler: ((Self) -> Void)?)
    func setHeaderDidEndDisplayHandler(_ handler: ((Self) -> Void)?)
}

public final class ZJSection: ZJBaseSection, ZJSectionable {}

open class ZJBaseSection {
    public var manager: ZJTableViewManager!
    public private(set) var items: [ZJItem] = []
    public var headerTitle: String?
    public var footerTitle: String?
    public var headerView: UIView?
    public var footerView: UIView?
    private var _headerHeight: CGFloat?
    private var _footerHeight: CGFloat?
    public var headerHeight: CGFloat {
        set {
            _headerHeight = newValue
        }
        get {
            if let _headerHeight = _headerHeight {
                return _headerHeight
            } else {
                return (manager.tableView.style == .grouped || headerTitle != nil) ? UITableView.automaticDimension : .leastNonzeroMagnitude
            }
        }
    }

    public var footerHeight: CGFloat {
        set {
            _footerHeight = newValue
        }
        get {
            if let _footerHeight = _footerHeight {
                return _footerHeight
            } else {
                return (manager.tableView.style == .grouped || footerTitle != nil) ? UITableView.automaticDimension : .leastNonzeroMagnitude
            }
        }
    }

    internal var _headerWillDisplayHandler: ((ZJBaseSection) -> Void)?
    internal var _headerDidEndDisplayHandler: ((ZJBaseSection) -> Void)?

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
        if let headerView = headerView {
            headerHeight = headerView.frame.size.height
        }

        if let footerView = footerView {
            footerHeight = footerView.frame.size.height
        }
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
        manager.tableView.beginUpdates()
        item.section = self
        items.insert(item, at: items.unwrappedIndex(afterItem) + 1)
        manager.tableView.insertRows(at: [item.indexPath], with: animate)
        manager.tableView.endUpdates()
    }

    public func insert(_ items: [ZJItem], afterItem: ZJItem, animate: UITableView.RowAnimation = .automatic) {
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

public extension ZJSectionable {
    func setHeaderDidEndDisplayHandler(_ handler: ((Self) -> Void)?) {
        _headerDidEndDisplayHandler = { handler?($0 as! Self) }
    }

    func setHeaderWillDisplayHandler(_ handler: ((Self) -> Void)?) {
        _headerWillDisplayHandler = { handler?($0 as! Self) }
    }
}

// MARK: - Equatable -

extension ZJBaseSection: Equatable {
    public static func == (lhs: ZJBaseSection, rhs: ZJBaseSection) -> Bool {
        return lhs === rhs
    }
}
