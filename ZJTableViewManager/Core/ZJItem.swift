//
//  ZJItem.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 . All rights reserved.
//

import UIKit

public protocol ZJItemable: ZJItem {
    static var cellClass: ZJBaseCell.Type { get }
    /// Cell点击事件的回调
    func setSelection(_ handler: ((Self) -> Void)?)
    /// Cell删除事件的回调
    func setDeletion(_ handler: ((Self) -> Void)?)
}

public extension ZJItemable {
    func setSelection(_ handler: ((Self) -> Void)?) {
        _selectionHandler = { handler?($0 as! Self) }
    }

    func setDeletion(_ handler: ((Self) -> Void)?) {
        _deletionHandler = { handler?($0 as! Self) }
    }
}

extension ZJItem: Equatable {
    public static func == (lhs: ZJItem, rhs: ZJItem) -> Bool {
        lhs === rhs
    }
}

open class ZJItem {
    public lazy var identifier = "\(type(of: self))"
    /// Cell height
    /// Specify the height or use UITableView.automaticDimension
    public var height: CGFloat = 44
    public var manager: ZJTableViewManager { section.manager }
    public var section: ZJBaseSection!
    
    internal var _selectionHandler: ((ZJItem) -> Void)?
    internal var _deletionHandler: ((ZJItem) -> Void)?

    public var editingStyle: UITableViewCell.EditingStyle = .none
    public var selectionStyle: UITableViewCell.SelectionStyle = .default

    public var indexPath: IndexPath {
        let sectionIndex = manager.sections.firstIndex(of: section)
        let rowIndex = section.firstIndex(of: self)
        return IndexPath(item: rowIndex!, section: sectionIndex!)
    }

    // 只保证Cell在屏幕上可见的情况下能获取到
    public var cell: UITableViewCell? {
        return manager.tableView.cellForRow(at: indexPath)
    }

    public init() {}

    public func reload(_ animation: UITableView.RowAnimation = .none) {
        zj_log("reload tableview at \(indexPath)")
        manager.tableView.reloadRows(at: [indexPath], with: animation)
    }

    public func select(animated: Bool = true, scrollPosition: UITableView.ScrollPosition = .none) {
        manager.tableView.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
    }

    public func deselect(animated: Bool = true) {
        manager.tableView.deselectRow(at: indexPath, animated: animated)
    }

    public func delete(_ animation: UITableView.RowAnimation = .automatic) {
        // 缓存indexPath，deleteRows传入的indexPath应当是删除之前的indexPath
        let indexPath = self.indexPath
        section.remove(at: indexPath.row)
        manager.tableView.deleteRows(at: [indexPath], with: animation)
    }
}
