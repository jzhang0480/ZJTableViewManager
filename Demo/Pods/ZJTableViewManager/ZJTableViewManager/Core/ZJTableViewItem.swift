//
//  ZJTableViewItem.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import UIKit
public typealias ZJTableViewItemBlock = (Any) -> ()

open class ZJTableViewItem: NSObject {
    weak var tableViewManager: ZJTableViewManager!
    public  var section: ZJTableViewSection!
    public var indexPath: IndexPath!
    public var cellIdentifier: String!
    public var cellHeight: CGFloat!
    /// 系统默认样式的cell
    public var systemCell: UITableViewCell?
    public var systemCellStyle: UITableViewCellStyle?
    /// cell点击事件的回调
    public var selectionHandler: ZJTableViewItemBlock?
    public var separatorInset: UIEdgeInsets?
    public var accessoryType: UITableViewCellAccessoryType?
    public var selectionStyle: UITableViewCellSelectionStyle?
    public var isSelectionAnimate:Bool! = false
    public var isHideSeparator: Bool = false
    public var separatorLeftMargin: CGFloat = 15
    
    public func setSelectionHandler(tempSelectHandler: ZJTableViewItemBlock?) {
        self.selectionHandler = tempSelectHandler
    }
    
    override public init() {
        super.init()
        cellIdentifier = NSStringFromClass(type(of: self))
        cellHeight = 44
    }
    
    convenience public init(tableViewCellStyle: UITableViewCellStyle = UITableViewCellStyle.default) {
        self.init()
        self.systemCellStyle = tableViewCellStyle
        self.cellIdentifier = self.cellIdentifier + String(tableViewCellStyle.rawValue)
        self.systemCell = UITableViewCell(style: tableViewCellStyle, reuseIdentifier: nil)
    }
    
    public func reload(_ animation: UITableViewRowAnimation) {
        print("reload tableview at \(indexPath)")
        tableViewManager.tableView.beginUpdates()
        tableViewManager.tableView.reloadRows(at: [indexPath], with: animation)
        tableViewManager.tableView.endUpdates()
    }
    
    public func delete(_ animation: UITableViewRowAnimation) {
        section.items.remove(at: self.indexPath.row)
        tableViewManager.tableView.deleteRows(at: [indexPath], with: animation)
    }
    
    open func updateHeight() {
        tableViewManager.tableView.beginUpdates()
        tableViewManager.tableView.endUpdates()
    }
    
}

