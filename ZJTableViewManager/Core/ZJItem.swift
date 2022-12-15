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
    func setSelectionHandler(_ handler: ((Self) -> Void)?)
    func setDeletionHandler(_ handler: ((Self) -> Void)?)
}

public extension ZJItemable {
    func setSelectionHandler(_ handler: ((Self) -> Void)?) {
        selectionHandler = { item in
            handler?(item as! Self)
        }
    }

    func setDeletionHandler(_ handler: ((Self) -> Void)?) {
        deletionHandler = { item in
            handler?(item as! Self)
        }
    }
}

open class ZJItem: NSObject {
    /// Cell height
    /// Specify the height or use UITableView.automaticDimension
    public var height: CGFloat = 44
    public var manager: ZJTableViewManager { section.manager }
    public var section: ZJSection!
    public lazy var identifier = "\(type(of: self))"

    /// cell点击事件的回调
    internal var selectionHandler: ((ZJItem) -> Void)?
    internal var deletionHandler: ((ZJItem) -> Void)?

    public var editingStyle: UITableViewCell.EditingStyle = .none
    public var selectionStyle: UITableViewCell.SelectionStyle = .default
    public var isSelected: Bool {
        return cell.isSelected
    }

    public var isAllowSelect = true

    public var indexPath: IndexPath {
        let sectionIndex = manager.sections.firstIndex(of: section)
        let rowIndex = section.firstIndex(of: self)
        return IndexPath(item: rowIndex!, section: sectionIndex!)
    }

    public var cell: UITableViewCell {
        if let unwrappedCell = manager.tableView.cellForRow(at: indexPath) {
            return unwrappedCell
        }
        zj_log("You didn't get that cell, so you have to get that cell after tableView is reload. Or the cell that gets the indexPath has to be on the screen, you can't get the cell that's off the screen")
        fatalError()
    }

    override public init() {
        super.init()
    }

    public func reload(_ animation: UITableView.RowAnimation) {
        zj_log("reload tableview at \(indexPath)")
        manager.tableView.beginUpdates()
        manager.tableView.reloadRows(at: [indexPath], with: animation)
        manager.tableView.endUpdates()
    }

    public func select(animated: Bool = true, scrollPosition: UITableView.ScrollPosition = .none) {
        if isAllowSelect {
            manager.tableView.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        }
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
