//
//  ZJItem.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 . All rights reserved.
//

import UIKit

public typealias ZJTableViewItemBlock = (ZJItemable) -> Void

public protocol ZJItemable: ZJItem {
    static var cellClass: ZJBaseCell.Type { get }
    func setSelection(_ handler: ((Self) -> Void)?)
    func setDeletion(_ handler: ((Self) -> Void)?)
}

public extension ZJItemable {
    func setSelection(_ handler: ((Self) -> Void)?) {
        selectionHandler = { item in
            handler?(item as! Self)
        }
    }

    func setDeletion(_ handler: ((Self) -> Void)?) {
        deletionHandler = { item in
            handler?(item as! Self)
        }
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
    public var section: ZJSection!

    /// Cell点击事件的回调
    internal var selectionHandler: ((ZJItem) -> Void)?
    /// Cell删除事件的回调
    internal var deletionHandler: ((ZJItem) -> Void)?

    public var editingStyle: UITableViewCell.EditingStyle = .none
    public var selectionStyle: UITableViewCell.SelectionStyle = .default

    public var indexPath: IndexPath {
        let sectionIndex = manager.sections.firstIndex(of: section)
        let rowIndex = section.firstIndex(of: self)
        return IndexPath(item: rowIndex!, section: sectionIndex!)
    }

    public var cell: UITableViewCell? {
        return manager.tableView.cellForRow(at: indexPath)
    }

    public init() {}

    public func reload(_ animation: UITableView.RowAnimation) {
        zj_log("reload tableview at \(indexPath)")
        manager.tableView.beginUpdates()
        manager.tableView.reloadRows(at: [indexPath], with: animation)
        manager.tableView.endUpdates()
    }

    public func select(animated: Bool = true, scrollPosition: UITableView.ScrollPosition = .none) {
        manager.tableView.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
    }

    public func deselect(animated: Bool = true) {
        manager.tableView.deselectRow(at: indexPath, animated: animated)
    }

    public func delete(_ animation: UITableView.RowAnimation = .automatic) {
        // Note: indexPath should be cached before remove, or it will changed after remove.
        let indexPath = self.indexPath
        section.remove(at: indexPath.row)
        manager.tableView.deleteRows(at: [indexPath], with: animation)
    }
}
