//
//  ZJTableViewItem.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import UIKit
public typealias ZJTableViewItemBlock = (ZJTableViewItem) -> Void

open class ZJTableViewItem: NSObject {
    public weak var tableViewManager: ZJTableViewManager!
    public weak var section: ZJTableViewSection!

    public var cellIdentifier: String!

    /// cell高度(如果要自动计算高度，使用autoHeight(manager:)方法，框架会算出高度，具体看demo)
    /// 传UITableViewAutomaticDimension则是系统实时计算高度，可能会有卡顿、reload弹跳等问题，不建议使用，有特殊需要可以选择使用
    public var cellHeight: CGFloat!
    /// cell点击事件的回调
    public var selectionHandler: ZJTableViewItemBlock?
    public func setSelectionHandler(selectHandler: ZJTableViewItemBlock?) {
        selectionHandler = selectHandler
    }

    public var deletionHandler: ZJTableViewItemBlock?
    public func setDeletionHandler(deletionHandler: ZJTableViewItemBlock?) {
        self.deletionHandler = deletionHandler
    }

    public var cellTitle: String?
    /// 系统默认样式的cell
    public var cellStyle: UITableViewCell.CellStyle = .default
    public var accessoryType: UITableViewCell.AccessoryType = .none
    public var selectionStyle: UITableViewCell.SelectionStyle = .default
    public var editingStyle: UITableViewCell.EditingStyle = .none

    public var isAutoDeselect: Bool = true

    public var indexPath: IndexPath {
        let rowIndex = self.section.items.zj_indexOf(self)

        let section = tableViewManager.sections.zj_indexOf(self.section)

        return IndexPath(item: rowIndex, section: section)
    }

    public override init() {
        super.init()
        cellIdentifier = NSStringFromClass(type(of: self)).components(separatedBy: ".").last
        cellHeight = 44
    }

    public convenience init(title: String?) {
        self.init()
        cellTitle = title
    }

    public func reload(_ animation: UITableView.RowAnimation) {
        print("reload tableview at \(indexPath)")
        tableViewManager.tableView.beginUpdates()
        tableViewManager.tableView.reloadRows(at: [indexPath], with: animation)
        tableViewManager.tableView.endUpdates()
    }

    public func delete(_ animation: UITableView.RowAnimation = .automatic) {
        if tableViewManager == nil || section == nil {
            print("Item did not in section，please check section.add() method")
            return
        }
        if !section.items.contains(where: { $0 == self }) {
            print("can't delete because this item did not in section")
            return
        }
        let indexPath = self.indexPath
        section.items.remove(at: indexPath.row)
        tableViewManager.tableView.deleteRows(at: [indexPath], with: animation)
    }

    /// 计算cell高度
    ///
    /// - Parameters:
    ///   - manager: 当前tableview的manager
    public func autoHeight(_ manager: ZJTableViewManager) {
        tableViewManager = manager
        let cell = manager.tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ZJInternalCellProtocol
        if cell == nil {
            print("please register cell")
        } else {
            cell?._item = self
            cellHeight = systemFittingHeightForConfiguratedCell(cell!)
        }
    }

    public func systemFittingHeightForConfiguratedCell(_ cell: ZJInternalCellProtocol) -> CGFloat {
        cell.cellWillAppear()

        let height = cell.systemLayoutSizeFitting(CGSize(width: tableViewManager.tableView.frame.width, height: 0), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        return height
    }
}
