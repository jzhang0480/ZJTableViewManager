//
//  ZJTableViewItem.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import UIKit
public typealias ZJTableViewItemBlock = (Any) -> ()

public class ZJTableViewItem: NSObject {
    weak var tableViewManager: ZJTableViewManager!
    var section: ZJTableViewSection!
    var indexPath: IndexPath!
    var cellIdentifier: String!
    var cellHeight: CGFloat!
    /// 系统默认样式的cell
    var systemCell: UITableViewCell?
    var systemCellStyle: UITableViewCellStyle?
    /// cell点击事件的回调
    var selectionHandler: ZJTableViewItemBlock?
    var separatorInset: UIEdgeInsets?
    var accessoryType: UITableViewCellAccessoryType?
    var selectionStyle: UITableViewCellSelectionStyle?
    var isSelectionAnimate:Bool! = false
    var isHideSeparator: Bool = false
    var separatorLeftMargin: CGFloat = 15
    
    func setSelectionHandler(tempSelectHandler: ZJTableViewItemBlock?) {
        self.selectionHandler = tempSelectHandler
    }
    
    override init() {
        super.init()
        cellIdentifier = NSStringFromClass(type(of: self))
        cellHeight = 44
    }
    
    convenience init(tableViewCellStyle: UITableViewCellStyle = UITableViewCellStyle.default) {
        self.init()
        self.systemCellStyle = tableViewCellStyle
        self.cellIdentifier = self.cellIdentifier + String(tableViewCellStyle.rawValue)
        self.systemCell = UITableViewCell(style: tableViewCellStyle, reuseIdentifier: nil)
    }
    
    func reload(_ animation: UITableViewRowAnimation) {
        print("reload tableview at \(indexPath)")
        tableViewManager.tableView.beginUpdates()
        tableViewManager.tableView.reloadRows(at: [indexPath], with: animation)
        tableViewManager.tableView.endUpdates()
    }
    
    func delete(_ animation: UITableViewRowAnimation) {
        section.items.remove(at: self.indexPath.row)
        tableViewManager.tableView.deleteRows(at: [indexPath], with: animation)
    }
    
    func updateHeight() {
        tableViewManager.tableView.beginUpdates()
        tableViewManager.tableView.endUpdates()
    }
    
}
