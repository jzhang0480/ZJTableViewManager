//
//  ZJItem.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 . All rights reserved.
//

import UIKit

public typealias ZJTableViewItemBlock = (ZJItem) -> Void

public protocol ZJItemable: ZJItem {
    static var cellClass: ZJBaseCell.Type { get }
}

open class ZJItem: NSObject {
    public var cellHeight: CGFloat!
    public var tableVManager: ZJTableViewManager { section.tableViewManager }
    public var section: ZJSection!
    public var cellIdentifier: String!

    /// cell点击事件的回调
    public var selectionHandler: ZJTableViewItemBlock?
    public func setSelectionHandler<T: ZJItem>(_ handler: ((_ callBackItem: T) -> Void)?) {
        selectionHandler = { item in
            handler?(item as! T)
        }
    }

    public var deletionHandler: ZJTableViewItemBlock?
    public func setDeletionHandler<T: ZJItem>(_ handler: ((_ callBackItem: T) -> Void)?) {
        deletionHandler = { item in
            handler?(item as! T)
        }
    }

    public var editingStyle: UITableViewCell.EditingStyle = .none

    public var selectionStyle: UITableViewCell.SelectionStyle = .default
    public var isSelected: Bool {
        return cell.isSelected
    }

    public var isAllowSelect = true

    public var indexPath: IndexPath {
        let rowIndex = self.section.items.zj_indexOf(self)
        let section = tableVManager.sections.zj_indexOf(self.section)
        return IndexPath(item: rowIndex, section: section)
    }

    public var cell: UITableViewCell {
        if let unwrappedCell = tableVManager.tableView.cellForRow(at: indexPath) {
            return unwrappedCell
        }
        zj_log("You didn't get that cell, so you have to get that cell after tableView is reload. Or the cell that gets the indexPath has to be on the screen, you can't get the cell that's off the screen")
        fatalError()
    }

    override public init() {
        super.init()
        cellIdentifier = "\(type(of: self))"
        cellHeight = 44
    }

    public func reload(_ animation: UITableView.RowAnimation) {
        zj_log("reload tableview at \(indexPath)")
        tableVManager.tableView.beginUpdates()
        tableVManager.tableView.reloadRows(at: [indexPath], with: animation)
        tableVManager.tableView.endUpdates()
    }

    public func select(animated: Bool = true, scrollPosition: UITableView.ScrollPosition = .none) {
        if isAllowSelect {
            tableVManager.tableView.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        }
    }

    public func deselect(animated: Bool = true) {
        tableVManager.tableView.deselectRow(at: indexPath, animated: animated)
    }

    public func delete(_ animation: UITableView.RowAnimation = .automatic) {
        if !section.items.contains(where: { $0 == self }) {
            zj_log("can't delete because this item did not in section")
            return
        }
        let indexPath = self.indexPath
        section.remove(at: indexPath.row)
        tableVManager.tableView.deleteRows(at: [indexPath], with: animation)
    }

    /// 计算cell高度
    ///
    /// - Parameters:
    ///   - manager: 当前tableview的manager
    public func autoHeight(_ manager: ZJTableViewManager) {
        manager.register([type(of: self) as! ZJItemable.Type])

        let unwrappedCell = manager.tableView.dequeueReusableCell(withIdentifier: cellIdentifier)

        if let cell = unwrappedCell as? ZJBaseCell {
            cell._item = self
        }

        if let cell = unwrappedCell as? ZJCellable {
            cell.cellPrepared()
        }
        cellHeight = unwrappedCell?.systemLayoutSizeFitting(CGSize(width: manager.tableView.frame.width, height: 0), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height ?? 0
    }
}
