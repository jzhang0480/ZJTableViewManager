//
//  ZJTableViewItem.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import UIKit
public typealias ZJTableViewItemBlock = (ZJTableViewItem) -> ()

open class ZJTableViewItem: NSObject {
    public weak var tableViewManager: ZJTableViewManager!
    public weak var section: ZJTableViewSection!
    public var cellTitle: String?
    public var cellIdentifier: String!
    
    /// cell高度(如果要自动计算高度，使用autoHeight(manager)方法，ZJ框架会算出高度)
    /// 传UITableViewAutomaticDimension则是系统实时计算高度，可能会有卡顿、reload弹跳等问题，不建议使用，有特殊需要可以选择使用
    public var cellHeight: CGFloat!
    /// 系统默认样式的cell
    //    public var systemCell: UITableViewCell?
    public var cellStyle: UITableViewCell.CellStyle?
    /// cell点击事件的回调
    public var selectionHandler: ZJTableViewItemBlock?
    public func setSelectionHandler(selectHandler: ZJTableViewItemBlock?) {
        self.selectionHandler = selectHandler
    }
    public var deletionHandler: ZJTableViewItemBlock?
    public func setDeletionHandler(deletionHandler: ZJTableViewItemBlock?) {
        self.deletionHandler = deletionHandler
    }
    public var separatorInset: UIEdgeInsets?
    public var accessoryType: UITableViewCell.AccessoryType?
    public var selectionStyle: UITableViewCell.SelectionStyle = UITableViewCell.SelectionStyle.default
    public var editingStyle: UITableViewCell.EditingStyle = UITableViewCell.EditingStyle.none
    public var isAutoDeselect: Bool! = true
    public var isHideSeparator: Bool = false
    public var separatorLeftMargin: CGFloat = 15
    public var indexPath: IndexPath {
        get {
            //            print("calculate item indexPath")
            let rowIndex = self.section.items.index(where: { (item) -> Bool in
                return item == self
            })
            
            let section = tableViewManager.sections.index(where: { (section) -> Bool in
                return section == self.section
            })
            
            return IndexPath(item: rowIndex!, section: section!)
        }
    }
    
    override public init() {
        super.init()
        cellIdentifier = NSStringFromClass(type(of: self)).components(separatedBy: ".").last
        cellHeight = 44
    }
    
    convenience public init(title: String?) {
        self.init()
        self.cellStyle = UITableViewCell.CellStyle.default
        self.cellTitle = title
    }
    
    public func reload(_ animation: UITableView.RowAnimation) {
        print("reload tableview at \(indexPath)")
        tableViewManager.tableView.beginUpdates()
        tableViewManager.tableView.reloadRows(at: [indexPath], with: animation)
        tableViewManager.tableView.endUpdates()
    }
    
    public func delete(_ animation: UITableView.RowAnimation = .automatic) {
        if tableViewManager == nil || section == nil {
            print("Item did not in section or manager，please check section.add() method")
            return;
        }
        if !self.section.items.contains(where: {$0 == self}) {
            print("can't delete because this item did not in section")
            return;
        }
        let indexPath = self.indexPath
        section.items.remove(at: indexPath.row)
        tableViewManager.tableView.deleteRows(at: [indexPath], with: animation)
    }
    
    open func updateHeight() {
        tableViewManager.tableView.beginUpdates()
        tableViewManager.tableView.endUpdates()
    }
    
    /// 在这个方法里面给cell赋值
    ///
    /// - Parameters:
    ///   - manager: 当前tableview的manager
    ///   - cellClass: 当前计算高度的cell的类型
    ///   - fillCellData: 回调方法
    @available(*, deprecated)
    public func autoHeight<T>(_ manager: ZJTableViewManager, _ cellClass: T.Type, _ fillCellData: ((T)->())?) {
        //由于本方法已经废弃, 直接调用新方法
        autoHeight(manager)
    }
    
    
    
    /// 计算cell高度
    ///
    /// - Parameters:
    ///   - manager: 当前tableview的manager
    public func autoHeight(_ manager: ZJTableViewManager) {
        tableViewManager = manager
        let cell = manager.tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ZJTableViewCell
        if cell == nil {
            print("please register cell")
        }else{
            cell?.item = self;
            cellHeight = systemFittingHeightForConfiguratedCell(cell!)
        }
    }
    
    
    
    public func systemFittingHeightForConfiguratedCell(_ cell: ZJTableViewCell) -> CGFloat {
        cell.cellWillAppear()
        let height = cell.systemLayoutSizeFitting(CGSize(width: tableViewManager.tableView.frame.width, height: 0), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        return height
    }
    
    
}

