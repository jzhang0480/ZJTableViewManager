//
//  ZJTableViewManager.swift
//  NewRetail
//
//  Created by Javen on 2018/2/8.
//  Copyright © 2018年 上海勾芒信息科技有限公司. All rights reserved.
//

import UIKit

open class ZJTableViewManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    public var tableView:UITableView!
    public var sections: [Any] = []
    
    public init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self;
        self.tableView.layoutMargins = UIEdgeInsets.zero
        self.registerDefaultCells()
    }
    
    func registerDefaultCells() {
        let myBundle = Bundle(for: ZJTextItem.self)
        self.register(ZJTextCell.self, ZJTextItem.self, myBundle)
        self.register(ZJTextFieldCell.self, ZJTextFieldItem.self, myBundle)
        self.register(ZJSwitchCell.self, ZJSwitchItem.self, myBundle)
    }
    
    public func register(_ nibClass: AnyClass, _ item: AnyClass, _ bundle: Bundle = Bundle.main) {
        if (bundle.path(forResource: "\(nibClass)", ofType: "nib") != nil) {
            self.tableView.register(UINib.init(nibName: "\(nibClass)", bundle: bundle), forCellReuseIdentifier: NSStringFromClass(item))
        }else{
            self.tableView.register(nibClass, forCellReuseIdentifier: NSStringFromClass(item))
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let currentSection = sections[section] as! ZJTableViewSection
        return currentSection.headerHeight
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let currentSection = sections[section] as! ZJTableViewSection
        return currentSection.headerView
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let currentSection = sections[section] as! ZJTableViewSection
        return currentSection.footerHeight
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let currentSection = sections[section] as! ZJTableViewSection
        return currentSection.footerView
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = sections[section] as! ZJTableViewSection
        return currentSection.items.count;
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentSection = sections[indexPath.section] as! ZJTableViewSection
        let item = currentSection.items[indexPath.row] as! ZJTableViewItem
        return item.cellHeight
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = sections[indexPath.section] as! ZJTableViewSection
        let item = currentSection.items[indexPath.row] as! ZJTableViewItem
        item.indexPath = indexPath
        item.tableViewManager = self
        //报错在这里，可能是是没有register cell 和 item
        var cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier) as? ZJTableViewCell
        
        if let systemCell = item.systemCell {
            if cell == nil {
                cell = ZJTableViewCell(style: item.systemCellStyle!, reuseIdentifier: item.cellIdentifier)
            }
            self.transform(fromLabel: systemCell.textLabel, toLabel: cell?.textLabel)
            self.transform(fromLabel: systemCell.detailTextLabel, toLabel: cell?.detailTextLabel)
        }
        
        if let separatorInset = item.separatorInset {
            cell?.separatorInset = separatorInset
        }
        
        if let accessoryType = item.accessoryType {
            cell?.accessoryType = accessoryType
        }else{
            cell?.accessoryType = .none
        }
        
        if let selectionStyle = item.selectionStyle {
            cell?.selectionStyle = selectionStyle
        }
        
        cell?.item = item
        cell?.cellWillAppear()
        
        return cell!;
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //        print("didEndDisplaying")
        (cell as! ZJTableViewCell).cellDidDisappear()
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //        print("willDisplay")
        (cell as! ZJTableViewCell).cellDidAppear()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentSection = sections[indexPath.section] as! ZJTableViewSection
        let item = currentSection.items[indexPath.row] as! ZJTableViewItem
        if item.isSelectionAnimate {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        item.selectionHandler?(item)
    }
    
    public func add(section: Any) {
        if !(section as AnyObject).isKind(of: ZJTableViewSection.self) {
            print("error section class")
            return
        }
        (section as! ZJTableViewSection).tableViewManager = self
        self.sections.append(section)
    }
    
    public func remove(section: Any) {
        if !(section as AnyObject).isKind(of: ZJTableViewSection.self) {
            print("error section class")
            return
        }
        self.sections.remove(at: self.sections.index(where: { (current) -> Bool in
            return (current as! ZJTableViewSection) == (section as! ZJTableViewSection)
        })!)
    }
    
    public func reload() {
        self.tableView.reloadData()
    }
    
    public func transform(fromLabel:UILabel?, toLabel:UILabel?) {
        toLabel?.text = fromLabel?.text
        toLabel?.font = fromLabel?.font
        toLabel?.textColor = fromLabel?.textColor
        toLabel?.textAlignment = (fromLabel?.textAlignment)!
        if let string = fromLabel?.attributedText {
            toLabel?.attributedText = string
        }
    }
}

