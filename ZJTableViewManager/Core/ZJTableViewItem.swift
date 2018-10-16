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
    public var cellHeight: CGFloat!
    /// 系统默认样式的cell
    //    public var systemCell: UITableViewCell?
    public var cellStyle: UITableViewCellStyle?
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
    public var accessoryType: UITableViewCellAccessoryType?
    public var selectionStyle: UITableViewCellSelectionStyle = UITableViewCellSelectionStyle.default
    public var editingStyle: UITableViewCellEditingStyle = UITableViewCellEditingStyle.none
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
        self.cellStyle = UITableViewCellStyle.default
        self.cellTitle = title
    }
    
    public func reload(_ animation: UITableViewRowAnimation) {
        print("reload tableview at \(indexPath)")
        tableViewManager.tableView.beginUpdates()
        tableViewManager.tableView.reloadRows(at: [indexPath], with: animation)
        tableViewManager.tableView.endUpdates()
    }
    
    public func delete(_ animation: UITableViewRowAnimation = .automatic) {
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
    public func autoHeight<T>(_ manager: ZJTableViewManager, _ cellClass: T.Type, _ fillCellData: ((T)->())?) {
        tableViewManager = manager
        let cell = manager.tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            print("please register cell")
        }else{
            fillCellData?(cell as! T)
            cellHeight = systemFittingHeightForConfiguratedCell(cell!)
        }
    }
    
    public func systemFittingHeightForConfiguratedCell(_ cell: UITableViewCell) -> CGFloat {
        var contentViewWidth = self.tableViewManager.tableView.frame.width
        
        var cellBounds = cell.bounds
        cellBounds.size.width = contentViewWidth
        cell.bounds = cellBounds
        
        var accessroyWidth: CGFloat = 0
        
        if let accessoryView = cell.accessoryView {
            // 15为系统cell左边的空隙
            accessroyWidth = 16 + accessoryView.frame.width
        } else {
            let systemAccessoryWidths: [UITableViewCellAccessoryType: CGFloat] = [
                .none: 0,
                .disclosureIndicator: 34,
                .detailDisclosureButton: 68,
                .checkmark: 40,
                .detailButton: 48,
                ]
            accessroyWidth = systemAccessoryWidths[cell.accessoryType] ?? 0
        }
        contentViewWidth -= accessroyWidth
        
        var fittingHeight: CGFloat = 0
        if contentViewWidth > 0 {
            
            let widthFenceConstraint = NSLayoutConstraint(item: cell.contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: contentViewWidth)
            
            var edgeConstraints: [NSLayoutConstraint] = []
            if isSystemVersionEqualOrGreaterThen10_2 {
                // To avoid confilicts, make width constraint softer than required (1000)
                widthFenceConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.required.rawValue - 1)
                
                // Build edge constraints
                let leftConstraint = NSLayoutConstraint(item: cell.contentView, attribute: .left, relatedBy: .equal, toItem: cell, attribute: .left, multiplier: 1, constant: 0)
                let rightConstraint = NSLayoutConstraint(item: cell.contentView, attribute: .right, relatedBy: .equal, toItem: cell, attribute: .right, multiplier: 1, constant: accessroyWidth)
                let topConstraint = NSLayoutConstraint(item: cell.contentView, attribute: .top, relatedBy: .equal, toItem: cell, attribute: .top, multiplier: 1, constant: 0)
                let bottomConstraint = NSLayoutConstraint(item: cell.contentView, attribute: .bottom, relatedBy: .equal, toItem: cell, attribute: .bottom, multiplier: 1, constant: 0)
                
                edgeConstraints = [leftConstraint, rightConstraint, topConstraint, bottomConstraint]
                cell.addConstraints(edgeConstraints)
            }
            
            cell.contentView.addConstraint(widthFenceConstraint)
            
            fittingHeight = cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            
            cell.contentView.removeConstraint(widthFenceConstraint)
            if isSystemVersionEqualOrGreaterThen10_2 {
                cell.removeConstraints(edgeConstraints)
            }
            
        }
        
        if fittingHeight == 0 {
            
            fittingHeight = cell.sizeThatFits(CGSize(width: contentViewWidth, height: 0)).height
            
        }
        
        if fittingHeight == 0 {
            fittingHeight = 44
        }
        
        if self.tableViewManager.tableView.separatorStyle != .none {
            fittingHeight += 1.0 / UIScreen.main.scale
        }
        
        return fittingHeight
    }
    
    private var isSystemVersionEqualOrGreaterThen10_2: Bool {
        return UIDevice.current.systemVersion.compare("10.2", options: .numeric) == .orderedDescending
    }
    
    
}

