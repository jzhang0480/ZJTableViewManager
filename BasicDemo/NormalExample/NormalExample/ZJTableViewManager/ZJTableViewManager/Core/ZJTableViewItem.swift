//
//  ZJTableViewItem.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 . All rights reserved.
//

import UIKit

public typealias ZJTableViewItemBlock = (ZJTableViewItem) -> Void

open class ZJTableViewItem: NSObject {
    public var tableVManager: ZJTableViewManager {
        return section.tableViewManager
    }
    public weak var section: ZJTableViewSection!
    public var cellIdentifier: String!
    /// cell高度(如果要自动计算高度，使用autoHeight(manager:)方法，框架会算出高度，具体看demo)
    /// 传UITableViewAutomaticDimension则是系统实时计算高度，可能会有卡顿、reload弹跳等问题，不建议使用，有特殊需要可以选择使用
    public var cellHeight: CGFloat!
    /// cell点击事件的回调
    public var selectionHandler: ZJTableViewItemBlock?
    public func setSelectionHandler<T: ZJTableViewItem>(_ handler: ((_ callBackItem: T) -> Void)?) {
        selectionHandler = { item in
            handler?(item as! T)
        }
    }

    public var deletionHandler: ZJTableViewItemBlock?
    public func setDeletionHandler<T: ZJTableViewItem>(_ handler: ((_ callBackItem: T) -> Void)?) {
        deletionHandler = { item in
            handler?(item as! T)
        }
    }

    public var labelText: String?
    public var detailLabelText: String?
    public var textAlignment: NSTextAlignment = .left
    public var detailTextAlignment: NSTextAlignment = .left
    public var image: UIImage?
    public var highlightedImage: UIImage?
    public var style: UITableViewCell.CellStyle = .default
    public var accessoryType: UITableViewCell.AccessoryType = .none
    public var selectionStyle: UITableViewCell.SelectionStyle = .default
    public var editingStyle: UITableViewCell.EditingStyle = .none
    public var accessoryView: UIView?
    public var isAutoDeselect: Bool = true
    public var selected: Bool {
        get{
            return cell.isSelected
        }
    }

    public var indexPath: IndexPath {
        let rowIndex = self.section.items.zj_indexOf(self)
        let section = tableVManager.sections.zj_indexOf(self.section)
        return IndexPath(item: rowIndex, section: section)
    }

    /// 尽量避免通过此属性直接修改cell里面的元素，直接修改cell没有修改修改数据源，由于TableViewCell的复用，会造成异常（正确做法是修改item的属性，通过item.reload()来刷新cell）
    public var cell: UITableViewCell {
        if let unwrappedCell = tableVManager.tableView.cellForRow(at: indexPath) {
            return unwrappedCell
        }
        zj_log("没有获取到对应的cell，必须在tableView reload之后才能通过这个属性获取到cell。或者获取的indexPath对应的cell必须在屏幕内，无法获取屏幕外的cell")
        fatalError()
    }

    public override init() {
        super.init()
        cellIdentifier = NSStringFromClass(type(of: self)).components(separatedBy: ".").last
        cellHeight = 44
    }

    public convenience init(text: String?) {
        self.init()
        labelText = text
    }

    public func reload(_ animation: UITableView.RowAnimation) {
        zj_log("reload tableview at \(indexPath)")
        tableVManager.tableView.beginUpdates()
        tableVManager.tableView.reloadRows(at: [indexPath], with: animation)
        tableVManager.tableView.endUpdates()
    }
    
    public func select(animated: Bool = true, scrollPosition: UITableView.ScrollPosition = .none) {
        tableVManager.tableView.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
    }
    
    public func deselect(animated: Bool = true) {
        tableVManager.tableView.deselectRow(at: indexPath, animated: animated)
    }

    public func delete(_ animation: UITableView.RowAnimation = .automatic) {
        if tableVManager == nil || section == nil {
            zj_log("Item did not in section，please check section.add() method")
            return
        }
        if !section.items.contains(where: { $0 == self }) {
            zj_log("can't delete because this item did not in section")
            return
        }
        let indexPath = self.indexPath
        section.items.remove(at: indexPath.row)
        tableVManager.tableView.deleteRows(at: [indexPath], with: animation)
    }

    /// 计算cell高度
    ///
    /// - Parameters:
    ///   - manager: 当前tableview的manager
    public func autoHeight(_ manager: ZJTableViewManager) {
        guard let cell = manager.tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ZJInternalCellProtocol else {
            zj_log("please register cell")
            return
        }
        
        cell._item = self
        cell.cellWillAppear()
        cellHeight = cell.systemLayoutSizeFitting(CGSize(width: manager.tableView.frame.width, height: 0), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
    }

}
