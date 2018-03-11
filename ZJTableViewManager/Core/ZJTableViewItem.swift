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
    weak var tableViewManager: ZJTableViewManager!
    public var section: ZJTableViewSection!
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
    public var isSelectionAnimate:Bool! = true
    public var isHideSeparator: Bool = false
    public var separatorLeftMargin: CGFloat = 15
    public var indexPath: IndexPath {
        get {
//            print("calculate item indexPath")
            let rowIndex = self.section.items.index(where: { (item) -> Bool in
                return (item as! ZJTableViewItem) == self
            })
            
            let section = tableViewManager.sections.index(where: { (section) -> Bool in
                return (section as! ZJTableViewSection) == self.section
            })
            
            return IndexPath(item: rowIndex!, section: section!)
        }
    }
    
    override public init() {
        super.init()
        cellIdentifier = NSStringFromClass(type(of: self))
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
        let indexPath = self.indexPath
        section.items.remove(at: indexPath.row)
        tableViewManager.tableView.deleteRows(at: [indexPath], with: animation)
    }
    
    open func updateHeight() {
        tableViewManager.tableView.beginUpdates()
        tableViewManager.tableView.endUpdates()
    }
    
}

