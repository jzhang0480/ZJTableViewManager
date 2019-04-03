//
//  ZJTableViewSection.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import UIKit

public typealias ZJTableViewSectionBlock = (ZJTableViewSection) -> ()

open class ZJTableViewSection: NSObject {
    public  weak var tableViewManager: ZJTableViewManager!
    public var items = [ZJTableViewItem]()
    public var headerHeight: CGFloat!
    public var footerHeight: CGFloat!
    public var headerView: UIView?
    public var footerView: UIView?
    public var headerTitle: String?
    public var footerTitle: String?
    var headerWillDisplayHandler: ZJTableViewSectionBlock?
    public func setHeaderWillDisplayHandler(_ block: ZJTableViewSectionBlock?) {
        self.headerWillDisplayHandler = block
    }
    var headerDidEndDisplayHandler: ZJTableViewSectionBlock?
    public func setHeaderDidEndDisplayHandler(_ block: ZJTableViewSectionBlock?) {
        self.headerDidEndDisplayHandler = block
    }
    public var index: Int {
        get {
            let section = tableViewManager.sections.index(where: { (section) -> Bool in
                return section == self
            })
            return section!
        }
    }
    
    override public init() {
        super.init()
        self.items = []
        self.headerHeight = CGFloat.leastNormalMagnitude
        self.footerHeight = CGFloat.leastNormalMagnitude
    }
    
    public convenience init(headerHeight: CGFloat!, color: UIColor) {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerHeight))
        headerView.backgroundColor = color
        self.init(headerView: headerView, footerView: nil)
    }
    
    public convenience init(headerTitle: String?, footerTitle: String?) {
        self.init()
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
    }
    
    public convenience init(headerTitle: String?) {
        self.init(headerTitle: headerTitle, footerTitle: nil)
    }
    
    public convenience init(footerTitle: String?) {
        self.init(headerTitle: nil, footerTitle: footerTitle)
    }
    
    public convenience init(headerView: UIView!) {
        self.init(headerView: headerView, footerView: nil)
    }
    
    public convenience init(footerView: UIView?) {
        self.init(headerView: nil, footerView: footerView)
    }
    
    public convenience init(headerView: UIView?, footerView: UIView?) {
        self.init()
        if let header = headerView {
            self.headerView = header
            self.headerHeight = header.frame.size.height
        }
        
        if let footer = footerView {
            self.footerView = footer
            self.footerHeight = footer.frame.size.height
        }
    }
    
    public func add(item: ZJTableViewItem) {
        item.section = self
        item.tableViewManager = self.tableViewManager
        self.items.append(item)
    }
    
    public func remove(item: ZJTableViewItem) {
        if let index = items.index(where: {$0 == item}) {
            items.remove(at: index)
        }else{
            print("item not in this section")
        }
    }
    
    public func removeAllItems() {
        self.items.removeAll()
    }
    
    public func replaceItemsFrom(array: [ZJTableViewItem]!) {
        self.removeAllItems()
        self.items = self.items + array
    }
    
    public func insert(_ item: ZJTableViewItem!, afterItem: ZJTableViewItem, animate: UITableView.RowAnimation = .automatic) {
        if !self.items.contains(where: {$0 == afterItem}) {
            print("can't insert because afterItem did not in sections")
            return;
        }
        
        tableViewManager.tableView.beginUpdates()
        item.section = self
        item.tableViewManager = self.tableViewManager
        self.items.insert(item, at: self.items.index(where: {$0 == afterItem})! + 1)
        tableViewManager.tableView.insertRows(at: [item.indexPath], with: animate)
        tableViewManager.tableView.endUpdates()
    }
    
    public func insert(_ items: [ZJTableViewItem], afterItem: ZJTableViewItem, animate: UITableView.RowAnimation = .automatic) {
        if !self.items.contains(where: {$0 == afterItem}) {
            print("can't insert because afterItem did not in sections")
            return;
        }
        
        tableViewManager.tableView.beginUpdates()
        let newFirstIndex = self.items.index(where: {$0 == afterItem})! + 1
        self.items.insert(contentsOf: items, at: newFirstIndex)
        var arrNewIndexPath = [IndexPath]()
        for i in 0..<items.count {
            items[i].section = self
            items[i].tableViewManager = self.tableViewManager
            arrNewIndexPath.append(IndexPath(item: newFirstIndex + i, section: afterItem.indexPath.section))
        }
        tableViewManager.tableView.insertRows(at: arrNewIndexPath, with: animate)
        tableViewManager.tableView.endUpdates()
    }
    
    public func delete(_ itemsToDelete: [ZJTableViewItem], animate: UITableView.RowAnimation = .automatic) {
        guard itemsToDelete.count > 0 else { return }
        tableViewManager.tableView.beginUpdates()
        var arrNewIndexPath = [IndexPath]()
        for i in itemsToDelete {
            remove(item: i)
            arrNewIndexPath.append(i.indexPath)
        }
        tableViewManager.tableView.deleteRows(at: arrNewIndexPath, with: animate)
        tableViewManager.tableView.endUpdates()
    }
    
    public func reload(_ animation: UITableView.RowAnimation) {
        
        if let index = tableViewManager.sections.index(where: {$0 == self}) {
            tableViewManager.tableView.reloadSections(IndexSet(integer: index), with: animation)
        }else{
            print("section did not in manager！")
        }
        
    }
    
}

